import 'package:GIUTGIOT/src/utils/clothLoad.dart';
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

import 'package:GIUTGIOT/Dio/access_token_manager.dart';
import 'package:GIUTGIOT/src/utils/clothLoad.dart';



class PageSlide extends StatefulWidget {
  const PageSlide({super.key});

  @override
  State<PageSlide> createState() => _PageSlideState();
}

class _PageSlideState extends State<PageSlide> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;
  bool showMotionButton = false; // 모션 버튼 표시 여부
  bool showWalkingGif = false; // 걷기 상태일 때 walking.gif 표시 여부

  @override
  void initState() {
    super.initState();
    ClothLoad().testFetchClothesByMemory();
    _fetchDailyCoordinate(DateTime.now());

  }

  Future<void> _fetchDailyCoordinate(DateTime date) async {
    try {
      // 여기에 token을 가져오는 로직을 추가해야 할 수 있습니다.
      String? token = await AccessTokenManager.getAccessToken();
      final response = await fetchDailyCoordinate(date, token ?? "");

      // 응답이 성공적이라면 showMotionButton 설정
      setState(() {
        showMotionButton = response == null;
      });
      print('fetchDailyCoordinate successful: $response');
    } catch (e) {
      print('fetchDailyCoordinate failed: $e');
      setState(() {
        showMotionButton = true; // 오류 발생 시 모션 버튼을 표시
      });
    }
  }

  // 센서 데이터를 바탕으로 걷기 상태 업데이트
  void _updateWalkingGifBasedOnSensor(bool isWalking) {
    setState(() {
      showWalkingGif = isWalking; // 걷기 감지 시 walking.gif를 표시
    });
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
                await _fetchDailyCoordinate(DateTime.now()); // 선택된 날짜로 데이터 확인
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
          if (currentPageIndex == 1 && showMotionButton != null)
            Positioned(
              bottom: 20,
              right: 45,
              child: MotionButton(onSelectionComplete: () {}),
            ),
          // 걷기 상태일 때 작은 walking.gif 표시
          if (showWalkingGif)
            Positioned(
              top: 20,
              right: 20,
              child: Image.asset(
                'assets/icon/walking.gif',
                width: 50, // 이미지 크기를 작게 설정
                height: 50,
              ),
            ),
        ],
      ),
    );
  }
}

