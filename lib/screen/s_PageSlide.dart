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
  bool showMotionButton = false; // 모션 버튼 표시 여부

  @override
  void initState() {
    super.initState();
    _checkSelectedDayClothes(DateTime.now()); // 초기 날짜로 데이터 확인
  }

  Future<void> _checkSelectedDayClothes(DateTime date) async {
    try {
      final response = await saveSelecteddayClothes(date);
      print('########### $response');

      // 응답이 null인 경우, 즉 오류나 데이터가 없는 경우에 대한 처리
      setState(() {
        showMotionButton = response == null;
      });
    } catch (e) {
      setState(() {
        showMotionButton = true; // 오류 발생 시 모션 버튼을 표시
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // PageController 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController, // 페이지 컨트롤러 설정
            scrollDirection: Axis.vertical,
            onPageChanged: (index) async {
              setState(() {
                currentPageIndex = index;
              });
              if (index == 1) {
                await _checkSelectedDayClothes(DateTime.now()); // 선택된 날짜로 데이터 확인
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
          // 조건에 따라 MotionButton 표시
          if (currentPageIndex == 1 && showMotionButton)
            Positioned(
              bottom: 20,
              right: 45,
              child: MotionButton(onSelectionComplete: () {}),
            ),
        ],
      ),
    );
  }
}
