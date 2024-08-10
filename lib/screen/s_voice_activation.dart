import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import '../Dio/config.dart'; // config.dart 파일을 임포트
import '../Dio/access_token_manager.dart'; // access_token_manager.dart 파일을 임포트

class VoiceActivationScreen extends StatefulWidget {
  @override
  _VoiceActivationScreenState createState() => _VoiceActivationScreenState();
}

class _VoiceActivationScreenState extends State<VoiceActivationScreen> {
  bool _isRecording = false; // 녹음 중인지 여부를 나타내는 플래그
  String _text = ''; // 인식된 텍스트를 저장하는 변수
  late stt.SpeechToText _speech; // 음성 인식 객체
  late IOS9SiriWaveformController _waveController; // Siri 파형 컨트롤러
  late FlutterTts _flutterTts; // TTS 객체
  bool _isListeningForResponse = false; // 응답을 듣고 있는지 여부를 나타내는 플래그
  String? _clothingImageUrl; // 받아온 의상 이미지 URL을 저장하는 변수
  Map<String, dynamic>? _clothesDetail; // 옷의 세부 정보를 저장하는 변수

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _waveController = IOS9SiriWaveformController();
    _flutterTts = FlutterTts();
    _initializeTts();
    _fetchToken();
  }

  void _initializeTts() {
    _flutterTts.setCompletionHandler(() {
      if (_isListeningForResponse && mounted) {
        if (!_speech.isListening) {
          _listen();
        }
      }
    });
  }

  Future<void> _fetchToken() async {
    bool success = await AccessTokenManager.fetchAndSaveToken();
    if (!success) {
      print('Failed to fetch and save token'); // 토큰 가져오기 실패 시 로그 출력
    }
  }

  Future<void> _listen() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission denied');
      return;
    }

    bool available = await _speech.initialize();
    print('Speech recognition available: $available');
    if (available) {
      _speech.listen(
        onResult: (val) {
          if (mounted) {
            setState(() {
              _text = val.recognizedWords;
              _waveController.amplitude = (val.confidence ?? 1.0) * 0.5;
              print('Recognized words: $_text');
            });
            if (val.finalResult) {
              _sendTextToServer(_text);
            }
          }
        },
      );
      if (mounted) {
        setState(() {
          _isRecording = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (mounted) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _sendTextToServer(String text) async {
    try {
      String? accessToken = await AccessTokenManager.getAccessToken();
      if (accessToken == null) {
        print('Access token is missing');
        return;
      }

      final dio = Dio();
      print('Sending text to server: $text');
      final response = await dio.post(
        Config.getConversationUri().toString(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: jsonEncode(<String, String>{'text': text}),
      );
      print('Server response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('Server response data: $responseData');

        if (responseData['type'] == 'Question') {
          String message = responseData['message'];
          await _speak(message);

          if (responseData.containsKey('clothesId')) {
            String clothesId = responseData['clothesId'].toString();
            _fetchClothesDetail(clothesId, accessToken); // 옷 세부 정보 조회
          }
        } else {
          _isListeningForResponse = false;
        }
      } else {
        print('Failed to send text: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending text: $e');
    }
  }

  Future<void> _fetchClothesDetail(String clothesId, String token) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        Config.getClothesUri(clothesId).toString(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _clothesDetail = response.data; // 옷 세부 정보를 저장
          print('Clothes detail fetched: $_clothesDetail'); // 디버깅용 로그
        });
      } else {
        print('Failed to fetch clothes detail: ${response.statusCode}'); // 실패 로그
      }
    } catch (e) {
      print('Error fetching clothes detail: $e'); // 오류 로그
    }
  }

  Future<void> _speak(String text) async {
    print('Speaking text: $text');
    await _flutterTts.speak(text);
    _isListeningForResponse = true;
  }

  @override
  void dispose() {
    _speech.cancel();
    _flutterTts.stop();
    super.dispose();
    print('Disposed VoiceActivationScreen');
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
                await _speech.cancel();
                await _flutterTts.stop();
                Navigator.pop(context);
                print('Back button pressed');
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_clothingImageUrl != null)
                  Image.network(
                    _clothingImageUrl!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Failed to load image', style: TextStyle(color: Colors.red));
                    },
                  ),
                if (_clothesDetail != null) ...[
                  Text('Clothes ID: ${_clothesDetail!['clothesId']}'),
                  Text('Color: ${_clothesDetail!['color']}'),
                  Text('Category: ${_clothesDetail!['category']}'),
                  Text('Type: ${_clothesDetail!['type']}'),
                  Text('Pattern: ${_clothesDetail!['pattern']}'),
                ],
                SizedBox(height: 20),
                SiriWaveform.ios9(
                  controller: _waveController,
                  options: IOS9SiriWaveformOptions(
                    height: 150,
                    width: 300,
                    showSupportBar: true,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_isRecording) {
                      await _stopListening();
                      print('Stopped recording');
                    } else {
                      await _listen();
                      print('Started recording');
                    }
                  },
                  child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
