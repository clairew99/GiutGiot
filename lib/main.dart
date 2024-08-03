import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 240731 SHJ: 홈 화면을 HomePage로 설정
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 240802 SHJ: 디버그 태그를 숨김
      home: HomePage(),
    );
  }
}
