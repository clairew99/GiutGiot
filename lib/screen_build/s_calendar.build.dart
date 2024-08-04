import 'package:flutter/material.dart';
import '../widget/button/bt_motion.dart';
import '../widget/function/w_calendar.dart';

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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CalendarWidget(),
        ),
        Positioned(
          bottom: 20,
          right: -40,
          child: MotionButton(),
        ),
      ],
    );
  }
}
