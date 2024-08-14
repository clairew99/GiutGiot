import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:GIUTGIOT/screen/s_calendar.dart';
import 'package:GIUTGIOT/src/myHome.dart';

import '../widget/button/bt_setting.dart'; // SettingsIcon 임포트
import '../widget/button/bt_slide.dart'; // SlideButton 임포트
import '../widget/button/bt_voice.dart'; // VoiceIcon 임포트
import '../widget/button/bt_motion.dart'; // 모션 버튼 임포트

class PageSlide extends StatefulWidget {
  const PageSlide({super.key});

  @override
  State<PageSlide> createState() => _PageSlideState();
}

class _PageSlideState extends State<PageSlide> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;

  void _refreshCalendar() {
    // 캘린더 새로고침 트리거
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Stack(
      children: [
        PageView(
          controller: _pageController, // 페이지 컨트롤러 설정
          scrollDirection: Axis.vertical,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          children: [
            // 페이지를 이동할 위젯들 정의
            HomeHourglassPage(),
            CalendarScreen(),
          ],
        ),
        Positioned(
          right: 10,
          top: MediaQuery.of(context).size.height / 2, // 앱 높이 / 2
          child: SlideBar(
            pageController: _pageController,
            itemCount: 2,
          ),
        ),
        SettingsIcon(
          onTap: () {
            Navigator.pushNamed(context, '/settings'); // 아이콘 클릭 시 설정 화면으로 이동
          },
        ),
        VoiceIcon(),
        currentPageIndex==1 ? Positioned( // 20, -40
          bottom: 20,
<<<<<<< HEAD
          right: -40,
=======
          right: 45,
>>>>>>> app
          child: MotionButton(onSelectionComplete: () {}),
        ):
        SizedBox.shrink()
      ]
      )
      );
      }

}
