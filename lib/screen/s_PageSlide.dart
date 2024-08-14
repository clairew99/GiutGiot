import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:GIUTGIOT/screen/s_calendar.dart';
import 'package:GIUTGIOT/src/myHome.dart';

import '../widget/button/bt_setting.dart'; // SettingsIcon 임포트
import '../widget/button/bt_slide.dart'; // SlideButton 임포트
import '../widget/button/bt_voice.dart'; // VoiceIcon 임포트
import '../widget/button/bt_motion.dart'; // 모션 버튼 임포트
import '../utils/clothes/clothes_request_manager.dart';


class PageSlide extends StatefulWidget {
  const PageSlide({super.key});

  @override
  State<PageSlide> createState() => _PageSlideState();
}

class _PageSlideState extends State<PageSlide> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;
  bool showMotionButton = false; // Variable to control the visibility of MotionButton

  @override
  void initState() {
    super.initState();
    _checkSelectedDayClothes(DateTime.now()); // Initial check with today's date or desired date
  }

  Future<void> _checkSelectedDayClothes(DateTime date) async {
    try {
      final response = await saveSelecteddayClothes(date);

      // Check if the response is null, indicating an error or no data
      setState(() {
        showMotionButton = response == null; // Show MotionButton if no valid data
      });
    } catch (e) {
      setState(() {
        showMotionButton = true; // Show MotionButton if an error occurs
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          PageView(
            controller: _pageController, // 페이지 컨트롤러 설정
            scrollDirection: Axis.vertical,
            onPageChanged: (index) async {
              setState(() {
                currentPageIndex = index;
              });
              if (index == 1) {
                await _checkSelectedDayClothes(DateTime.now()); // Replace DateTime.now() with the selected date
              }
            },
            children: [
              // 페이지를 이동할 위젯들 정의
              HomeHourglassPage(),
              const CalendarScreen(),
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
          const VoiceIcon(),
          // if (currentPageIndex == 1 ) // 조건에 따라 MotionButton 표시
          if (currentPageIndex == 1 && showMotionButton) // 조건에 따라 MotionButton 표시
            Positioned(
              bottom: 20,
              right: 45,
              child: MotionButton(onSelectionComplete: () {}),
            ),
        ]));
  }
}

