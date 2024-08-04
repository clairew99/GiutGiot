import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoiceActivationScreen extends StatefulWidget {
  @override
  _VoiceActivationScreenState createState() => _VoiceActivationScreenState();
}

class _VoiceActivationScreenState extends State<VoiceActivationScreen> {
  bool _isRecording = true;
  String _text = ''; // 인식된 텍스트 변수 추가
  late stt.SpeechToText _speech; // 음성 인식 객체

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // 음성 인식 객체 초기화
    _listen(); // 페이지 로드 시 음성 인식 시작
  }

  Future<void> _listen() async {
    await Permission.microphone.request();
    _speech.listen(onResult: (val) {
      setState(() {
        _text = val.recognizedWords; // 인식된 텍스트 업데이트
      });
      if (val.finalResult) {
        _sendTextToServer(_text); // 최종 결과를 서버로 전송
      }
    });
    setState(() {
      _isRecording = true;
    });
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
      appBar: AppBar(
        title: Text('Recording'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await _stopListening(); // 페이지 뒤로가기 시 음성 인식 중지
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
    );
  }
}
