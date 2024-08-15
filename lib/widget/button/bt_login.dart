import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String button1Text;
  final String button2Text;
  final String button3Text;
  final VoidCallback onPressedButton1; // 구글 로그인 콜백
  final VoidCallback onPressedButton2; // 네이버 로그인 콜백
  final VoidCallback onPressedButton3; // 카카오 로그인 콜백

  ButtonWidget({
    required this.button1Text,
    required this.button2Text,
    required this.button3Text,
    required this.onPressedButton1,
    required this.onPressedButton2,
    required this.onPressedButton3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: onPressedButton1,
          icon: Image.asset('assets/icon/google_icon.png', width: 24, height: 24),
          label: Text(
            button1Text,
            style: TextStyle(color: Colors.black), // 텍스트 색상 검정색으로 설정
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 구글 버튼 색상
            minimumSize: Size(200, 50), // 버튼 크기
          ),
        ),
        SizedBox(height: 10), // 버튼 사이 간격
        ElevatedButton.icon(
          onPressed: onPressedButton2,
          icon: Image.asset('assets/icon/naver_icon.png', width: 24, height: 24),
          label: Text(
            button2Text,
            style: TextStyle(color: Colors.black), // 텍스트 색상 검정색으로 설정
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00C73C), // 네이버 버튼 색상
            minimumSize: Size(200, 50), // 버튼 크기
          ),
        ),
        SizedBox(height: 10), // 버튼 사이 간격
        ElevatedButton.icon(
          onPressed: onPressedButton3,
          icon: Image.asset('assets/icon/kakao_icon.png', width: 24, height: 24),
          label: Text(
            button3Text,
            style: TextStyle(color: Colors.black), // 텍스트 색상 검정색으로 설정
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFAE100), // 카카오 버튼 색상
            minimumSize: Size(200, 50), // 버튼 크기
          ),
        ),
        SizedBox(height: 30), // 버튼과 화면 하단 사이 간격
      ],
    );
  }
}