import 'package:flutter/material.dart';

class CalendarContent extends StatelessWidget {
  const CalendarContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 이미지
        Positioned.fill(
          child: Image.asset(
            'assets/background/bg.gif',
            fit: BoxFit.cover,
          ),
        ),
        // 메인 콘텐츠
        Container(
          child: const Center(
            child: Text('Calendar Screen Content'),
          ),
        ),
      ],
    );
  }
}
