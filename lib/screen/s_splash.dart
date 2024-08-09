import 'package:flutter/material.dart';
import 's_servicedescription.dart'; // DescriptionService 가져오기
import 's_login.dart'; // LoginPage 가져오기
import 's_calendar.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9ECF0), // 배경색 변경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '기웃기옷',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/icon/sandhour.gif'), // GIF 이미지 추가
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DescriptionService()),
                );
              },
              child: Text('설명 보기'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('로그인'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CalendarPage()), // 여기에 적절한 캘린더 페이지 위젯을 넣으세요
                // );
              },
              child: Text('캘린더'),
            ),
          ],
        ),
      ),
    );
  }
}
