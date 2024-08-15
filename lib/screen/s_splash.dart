import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9ECF0), // 배경색 변경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon/app_icon.png'),
            Text(
              '기웃기옷',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
