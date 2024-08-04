import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../screen/s_voice_activation.dart'; // s_voice_activation.dart 파일 임포트

class VoiceIcon extends StatefulWidget {
  const VoiceIcon({Key? key}) : super(key: key);

  @override
  _VoiceIconState createState() => _VoiceIconState();
}

class _VoiceIconState extends State<VoiceIcon> {
  late stt.SpeechToText _speech; // 음성 인식 객체
  bool _isListening = false; // 현재 음성 인식 상태
  String _text = ''; // 인식된 텍스트

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // 음성 인식 객체 초기화
    initSpeech();
  }

  // 음성 인식 초기화
  Future<void> initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() {});
    }
  }

  // 음성 인식 시작/종료
  Future<void> _listen() async {
    if (!_isListening) {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords; // 인식된 텍스트 업데이트
            });
            if (val.finalResult) {
              _sendTextToServer(_text); // 최종 결과를 서버로 전송
            }
          },
        );
        setState(() {
          _isListening = true; // 음성 인식 상태 업데이트
        });
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false; // 음성 인식 상태 업데이트
      });
    }
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
      print("response : ${response.statusCode}");
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
    return Positioned(
      top: 45.0, // 상태 표시줄 아래 여백
      left: 25.0, // 왼쪽에서의 여백
      child: IconButton(
        icon: Icon(
          Icons.fiber_smart_record, // 기존 녹음 아이콘으로 변경
          color: Colors.black38, // 아이콘 색상
          size: 30, // 아이콘 크기
        ),
        onPressed: () async {
          await _listen(); // 음성 인식 시작
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VoiceActivationScreen()), // 녹음 페이지로 이동
          );
        },
      ),
    );
  }
}
