import 'package:flutter/material.dart';
import '../widget/button/bt_login.dart'; // ButtonWidget 가져오기

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true, // 타이틀을 가운데로 정렬
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100), // 로그인 페이지와 텍스트 사이 간격
          Stack(
            children: <Widget>[
              // 검정색 테두리 텍스트
              Text(
                '기웃기옷',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 7
                    ..color = Colors.black45,
                ),
              ),
              // 흰색 내부 텍스트
              Text(
                '기웃기옷',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 150), // 로고와 버튼 사이 간격
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonWidget(
                button1Text: 'Google 로그인',
                button2Text: 'Naver 로그인',
                button3Text: 'Kakao 로그인',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
