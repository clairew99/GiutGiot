import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:siri_wave/siri_wave.dart';
import 'dart:convert';

class VoiceActivationScreen extends StatefulWidget {
  @override
  _VoiceActivationScreenState createState() => _VoiceActivationScreenState();
}

class _VoiceActivationScreenState extends State<VoiceActivationScreen> {
  bool _isRecording = false;
  String _text = ''; // 인식된 텍스트 변수 추가
  late stt.SpeechToText _speech; // 음성 인식 객체
  late IOS9SiriWaveformController _waveController; // SiriWave 컨트롤러 초기화

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // 음성 인식 객체 초기화
    _waveController = IOS9SiriWaveformController(); // SiriWave 컨트롤러 초기화
  }

  Future<void> _listen() async {
    await Permission.microphone.request();
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (val) {
        setState(() {
          _text = val.recognizedWords; // 인식된 텍스트 업데이트
          _waveController.amplitude = (val.confidence ?? 1.0) * 0.5; // 웨이브폼 진폭 업데이트
        });
        if (val.finalResult) {
          _sendTextToServer(_text); // 최종 결과를 서버로 전송
        }
      });
      setState(() {
        _isRecording = true;
      });
    } else {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isRecording = false;
    });
  }

  // 인식된 텍스트를 서버로 전송
  Future<void> _sendTextToServer(String text) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/conversation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'text': text}),
      );

      if (response.statusCode == 200) {
        print('Text sent successfully');
      } else {
        print('Failed to send text');
      }
    } catch (e) {
      print('Error sending text: $e');
    }
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
                await _stopListening(); // 페이지 뒤로가기 시 음성 인식 중지
                Navigator.pop(context);
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
                    height: 360,
                    width: 360,
                    showSupportBar: true,
                  ),
                ),
                SizedBox(height: 20),
                Text(_isRecording ? 'Recording...' : 'Recording Stopped'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_isRecording) {
                      await _stopListening();
                    } else {
                      await _listen();
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
