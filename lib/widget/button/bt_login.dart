import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String button1Text;
  final String button2Text;
  final String button3Text;

  ButtonWidget({
    required this.button1Text,
    required this.button2Text,
    required this.button3Text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: () {
            // 구글 로그인 로직
          },
          icon: Image.asset('assets/google_icon.png', width: 24, height: 24),
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
          onPressed: () {
            // 네이버 로그인 로직
          },
          icon: Image.asset('assets/naver_icon.png', width: 24, height: 24),
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
          onPressed: () {
            // 카카오 로그인 로직
          },
          icon: Image.asset('assets/kakao_icon.png', width: 24, height: 24),
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
