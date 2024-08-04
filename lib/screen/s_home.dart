import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/sensor_management.dart';
import '../models/ml_model.dart';
import '../widget/button/bt_setting.dart'; // SettingsIcon 임포트
import '../widget/button/bt_voice.dart'; // VoiceIcon 임포트
import '../widget/w_home_build.dart'; // PageViewItem 임포트

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(); // PageController를 통한 스크롤 제어
  Interpreter? _interpreter; // TFLite Interpreter
  String activity = 'Unknown'; // 활동 상태 변수
  int maxIndex = 0; // maxIndex 변수 추가
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];

  @override
  void initState() {
    super.initState();
    // 상태 표시줄을 투명하게 설정
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 상태 표시줄 배경 투명
      statusBarIconBrightness: Brightness.light, // 상태 표시줄 아이콘 밝기
    ));

    // TFLite 모델 로드
    loadModel('assets/model/posture_analysis.tflite').then((interpreter) {
      setState(() {
        _interpreter = interpreter;
      });

      // 센서 초기화
      initializeSensors(_streamSubscriptions, (accelerometerValues, gyroscopeValues, userAccelerometerValues) {
        setState(() {});
      });

      // 센서 초기화 및 움직임 감지 시작
      if (_interpreter != null) {
        startMovementDetection(
          _interpreter!,
          predict,
              (int predictedMaxIndex) {
            setState(() {
              maxIndex = predictedMaxIndex;
              activity = getActivityText(maxIndex);
            });
          },
              () => setState(() {}), // onUpdate 콜백 추가
        );
      }
    });
  }

  @override
  void dispose() {
    // 스트림 구독 해제
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
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
          const VoiceIcon(),
          // 화면 하단에 예측 결과 표시
          Positioned(
            bottom: 50.0,
            left: 20.0,
            child: Text(
              'Current Activity: $activity',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
