import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../widget/w_home_build.dart'; // PageViewItem 임포트

import '../widget/button/bt_setting.dart'; // SettingsIcon 임포트
import '../widget/button/bt_voice.dart'; // VoiceIcon 임포트

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(); // PageController를 통한 스크롤 제어

  @override
  void initState() {
    super.initState();
    // 상태 표시줄을 투명하게 설정
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 상태 표시줄 배경 투명
      statusBarIconBrightness: Brightness.light, // 상태 표시줄 아이콘 밝기
    ));
  }

  @override
  void dispose() {
    _pageController.dispose(); // 위젯이 사라질 때 PageController 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // AppBar 뒤에 배경을 확장하여 그려줌
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController, // PageController를 통한 스크롤 상태 제어
            scrollDirection: Axis.vertical, // 수직 스크롤러 설정
            itemCount: 2, // 페이지 수 설정
            itemBuilder: (context, index) {
              return PageViewItem(
                pageController: _pageController,
                index: index,
              );
            },
          ),
          // 오른쪽 상단에 설정 아이콘 고정
          SettingsIcon(
            onTap: () {
              Navigator.pushNamed(context, '/settings'); // 아이콘 클릭 시 설정 화면으로 이동
            },
          ),
          // 왼쪽 상단에 음성 활성화 아이콘 고정
          // 음성 활성화 화면 이동 구현 X, 버튼만 있음 (24.08.03)
          const VoiceIcon(),
        ],
      ),
    );
  }
}
