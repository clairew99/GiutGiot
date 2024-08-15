import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import '../Dio/config.dart';
import '../Dio/access_token_manager.dart';
import 'package:dio/io.dart';

class VoiceActivationScreen extends StatefulWidget {
  @override
  _VoiceActivationScreenState createState() => _VoiceActivationScreenState();
}

class _VoiceActivationScreenState extends State<VoiceActivationScreen> {
  static const String _contentTypeHeader = 'Content-Type';
  static const String _contentTypeValue = 'application/json; charset=UTF-8';

  String _text = '';
  late stt.SpeechToText _speech;
  late IOS9SiriWaveformController _waveController;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _sendToResponse = false; // 다음 요청을 response로 보낼지 여부를 저장하는 플래그
  Map<String, dynamic>? _clothesDetail;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _waveController = IOS9SiriWaveformController();
    _flutterTts = FlutterTts();
    _initializeTts();
    _startListeningIfNotActive();
  }

  void _initializeTts() {
    _flutterTts.setStartHandler(() => print("TTS is starting"));
    _flutterTts.setCompletionHandler(() {
      print("TTS is completed");
      _startListeningIfNotActive();
    });
    _flutterTts.setErrorHandler((msg) => print("TTS error: $msg"));
  }

  Future<void> _startListeningIfNotActive() async {
    if (!_isListening) {
      await _listen();
    }
  }

  Future<void> _listen() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission denied');
      _showErrorDialog('권한 오류', '마이크 권한이 필요합니다.');
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech recognition status: $status'),
      onError: (errorNotification) => print('Speech recognition error: $errorNotification'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          if (mounted) {
            setState(() {
              _text = val.recognizedWords;
              _waveController.amplitude = (val.confidence ?? 1.0) * 0.5;
            });
            if (val.finalResult) {
              _sendTextToServer(_text);
              setState(() => _isListening = false);
            }
          }
        },
        onSoundLevelChange: (level) => _waveController.amplitude = level / 100,
        listenFor: Duration(seconds: 60),
        pauseFor: Duration(seconds: 10),
        cancelOnError: true,
      );
    } else {
      setState(() => _isListening = false);
      _showErrorDialog('음성 인식 오류', '음성 인식을 시작할 수 없습니다.');
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  // 서버로 텍스트와 토큰을 전송하는 메서드
  Future<void> _sendTextToServer(String text) async {
    try {
      String? accessToken = await AccessTokenManager.getAccessToken();

      print("accessToken: $accessToken");
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final dio = Dio();

      // 다음 요청이 /response로 가야 할 경우 URL을 변경
      final url = _sendToResponse
          ? 'http://127.0.0.1:5000/response'
          : 'http://127.0.0.1:5000/conversation';

      // 요청이 끝나면 다시 conversation으로 보내도록 플래그를 false로 리셋
      _sendToResponse = false;

      // 토큰을 body에 포함하여 서버로 전송
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            _contentTypeHeader: _contentTypeValue,
          },
        ),
        data: jsonEncode(<String, String>{'text': text, 'token': '$accessToken'}),
      );

      if (response.statusCode == 200) {
        print('STT 전송 완료~');
        final responseData = response.data;
        print('받은 데이터다! $responseData');

        if (responseData is Map<String, dynamic>) {
          String? message = responseData['message'] as String?;
          if (message != null) {
            setState(() => _text = message);
            await _speak(message);

            // 응답 메시지에 따라 다음 요청을 /response로 보낼지 결정
            if (message == "입어도 됩니다. 입으시겠어요?" ||
                message == "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?") {
              _sendToResponse = true;
            }
          }

          if (responseData.containsKey('clothesId')) {
            String clothesId = responseData['clothesId'].toString();
            await _fetchClothesDetail(clothesId, accessToken);
          }
        } else {
          print('Unexpected response type');
          _showErrorDialog('서버 응답 오류', '서버에서 잘못된 데이터를 수신했습니다.');
        }
      } else {
        throw Exception('Failed to send text: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending text to server: $e');
      _showErrorDialog('서버 통신 오류', '서버와의 통신 중 오류가 발생했습니다.');
    }
  }

  // 의류 상세 정보를 가져오는 메서드
  Future<void> _fetchClothesDetail(String clothesId, String token) async {
    try {
      final dio = Dio();

      // 토큰을 body에 포함하여 서버로 요청
      final response = await dio.post(
        Config.getClothesUri(clothesId).toString(),
        options: Options(
          headers: {
            _contentTypeHeader: _contentTypeValue,
          },
        ),
        data: jsonEncode(<String, String>{'clothesId': clothesId, 'token': '$token'}),
      );

      if (response.statusCode == 200) {
        setState(() => _clothesDetail = response.data);
      } else {
        throw Exception('Failed to fetch clothes detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching clothes detail: $e');
      _showErrorDialog('의류 정보 오류', '의류 정보를 가져오는데 실패했습니다.');
    }
  }

  Future<void> _speak(String text) async {
    if (_isListening) {
      await _stopListening();
    }
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
      _showErrorDialog('음성 출력 오류', '음성 출력 중 오류가 발생했습니다.');
      _startListeningIfNotActive();
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _stopListening();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/bg.gif',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                await _stopListening();
                Navigator.pop(context);
                print('Back button pressed');
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SiriWaveform.ios9(
                  controller: _waveController,
                  options: IOS9SiriWaveformOptions(
                    height: 300,
                    width: 300,
                    showSupportBar: true,
                  ),
                ),
                SizedBox(height: 20),
                Text(_text, style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_isListening) {
                      await _stopListening();
                      print('Stopped listening');
                    } else {
                      await _startListeningIfNotActive();
                      print('Started listening');
                    }
                  },
                  child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
