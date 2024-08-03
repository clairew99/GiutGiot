import 'package:flutter/material.dart';
import 'test_home_page.dart';

void main() => runApp(const TestApp());

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 240731 SHJ: 홈 화면을 HomePage로 설정
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // 240802 SHJ: 디버그 태그를 숨김
      home: TestPage(),
    );
  }
}
