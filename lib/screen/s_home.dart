import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../screen_build/s_home_build.dart'; // PageViewItem 임포트
import '../widget/button/bt_setting.dart'; // SettingsIcon 임포트
import '../widget/button/bt_voice.dart'; // VoiceIcon 임포트
import '../widget/button/bt_slide.dart'; // SlideButton 임포트

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: 2,
            itemBuilder: (context, index) {
              // PageViewItem이 정의된 파일이 올바르게 임포트 되었는지 확인
              return PageViewItem(
                pageController: _pageController,
                index: index,
              );
            },
          ),
          SettingsIcon(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const VoiceIcon(),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height / 2, // 앱 높이 / 2
            child: SlideBar(
              pageController: _pageController,
              itemCount: 2,
            ),
          ),
        ],
      ),
    );
  }
}
