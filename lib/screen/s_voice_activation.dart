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
    // TTS 완료 핸들러 설정
    _flutterTts.setCompletionHandler(() {
      if (_isListeningForResponse && mounted) {
        if (!_speech.isListening) { // 음성 인식이 진행 중이 아닐 때만 시작
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
    // 마이크 권한 요청
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission denied'); // 권한 거부 시 로그 출력
      return; // 권한이 거부된 경우 함수를 종료
    }

    // 음성 인식 초기화
    bool available = await _speech.initialize();
    print('Speech recognition available: $available'); // 디버깅용 로그
    if (available) {
      // 음성 인식 시작
      _speech.listen(
        onResult: (val) {
          if (mounted) {
            setState(() {
              _text = val.recognizedWords; // 인식된 단어를 저장
              _waveController.amplitude = (val.confidence ?? 1.0) * 0.5; // 자신감 값을 파형의 진폭으로 설정
              print('Recognized words: $_text'); // 디버깅용 로그
            });
            if (val.finalResult) {
              _sendTextToServer(_text); // 최종 결과가 나오면 서버로 전송
            }
          }
        },
      );
      if (mounted) {
        setState(() {
          _isRecording = true; // 녹음 중으로 상태 설정
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isRecording = false; // 녹음 중지로 상태 설정
        });
      }
    }
  }

  Future<void> _stopListening() async {
    // 음성 인식 중지
    await _speech.stop();
    if (mounted) {
      setState(() {
        _isRecording = false; // 녹음 중지로 상태 설정
      });
    }
  }

  Future<void> _sendTextToServer(String text) async {
    // 서버로 텍스트 전송
    try {
      String? accessToken = await AccessTokenManager.getAccessToken();
      if (accessToken == null) {
        print('Access token is missing'); // 액세스 토큰이 없을 때 로그 출력
        return;
      }

      final dio = Dio();
      print('Sending text to server: $text'); // 디버깅용 로그
      final response = await dio.post(
        Config.getConversationUri().toString(), // 설정 파일의 메서드를 통해 URI 생성
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken', // 액세스 토큰 추가
          },
        ),
        data: jsonEncode(<String, String>{'text': text}),
      );
      print('Server response status: ${response.statusCode}'); // 디버깅용 로그

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('Server response data: $responseData'); // 디버깅용 로그
        if (responseData['type'] == 'Question') {
          String message = responseData['message'];
          await _speak(message); // 서버의 응답 메시지를 읽음

          if (responseData.containsKey('clothesId')) {
            if (mounted) {
              setState(() {
                _clothingImageUrl = Config.getClothesUri(responseData['clothesId']).toString(); // 의상 이미지 URL을 업데이트
                print('Clothing image URL: $_clothingImageUrl'); // 디버깅용 로그
              });
            }
          }
        } else {
          _isListeningForResponse = false; // 응답 듣기 중지
        }
      } else {
        print('Failed to send text: ${response.statusCode}'); // 실패 로그
      }
    } catch (e) {
      print('Error sending text: $e'); // 오류 로그
    }
  }

  Future<void> _speak(String text) async {
    // TTS로 텍스트 읽기
    print('Speaking text: $text'); // 디버깅용 로그
    await _flutterTts.speak(text);
    _isListeningForResponse = true; // 응답 듣기 시작
  }

  @override
  void dispose() {
    // 리소스 해제
    _speech.cancel();
    _flutterTts.stop();
    super.dispose();
    print('Disposed VoiceActivationScreen'); // 디버깅용 로그
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/background/bg.gif',
              fit: BoxFit.cover,
            ),
          ),
          // 뒤로가기 버튼
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
                print('Back button pressed'); // 디버깅용 로그
              },
            ),
          ),
          // 중앙 컨텐츠
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 의상 이미지 표시
                if (_clothingImageUrl != null)
                  Image.network(
                    _clothingImageUrl!,
                    height: 200, // 이미지 높이 설정
                    width: 200, // 이미지 너비 설정
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Failed to load image', style: TextStyle(color: Colors.red));
                    },
                  ),
                SizedBox(height: 20),
                // Siri 파형
                SiriWaveform.ios9(
                  controller: _waveController,
                  options: IOS9SiriWaveformOptions(
                    height: 150, // 파형 높이 설정
                    width: 300, // 파형 너비 설정
                    showSupportBar: true,
                  ),
                ),
                SizedBox(height: 20),
                // 녹음 시작/중지 버튼
                ElevatedButton(
                  onPressed: () async {
                    if (_isRecording) {
                      await _stopListening();
                      print('Stopped recording'); // 디버깅용 로그
                    } else {
                      await _listen();
                      print('Started recording'); // 디버깅용 로그
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
