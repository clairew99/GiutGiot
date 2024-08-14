import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'models/sensor_management.dart';
import 'screen/s_setting.dart';
import 'screen/s_voice_activation.dart';
import 'screen/s_login.dart'; // 로그인 페이지 가져오기
import 'screen/s_PageSlide.dart';
import 'package:GIUTGIOT/Dio/access_token_manager.dart';
import 'dart:async';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'models/ml_model.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  Interpreter? _interpreter;
  bool _isLoggedIn = false;
  bool _isLoading = true;
  int maxIndex = 0;
  int prevMaxIndex = -1;
  String activity = 'Unknown';
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('앱 초기화 시작');
      await _requestPermissions();

      print('로그인 상태 확인 중...');
      _isLoggedIn = await AccessTokenManager.hasValidToken();
      print('로그인 상태: $_isLoggedIn');

      if (_isLoggedIn) {
        print('로그인됨, 센서 및 모델 초기화 시작');
        await setupSensorManagement();
        await _initializeModelAndSensors();
      } else {
        print('로그인되지 않음, 로그인 페이지 표시 예정');
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('앱 초기화 오류: $e');
    }
  }

  Future<void> _initializeModelAndSensors() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print("모델 로딩 중...");
      Interpreter interpreter = await loadModel('assets/model/posture_analysis.tflite');
      setState(() {
        _interpreter = interpreter;
        _isLoading = false;
      });

      print("센서 초기화 중...");
      initializeSensors(_streamSubscriptions, (accelerometerValues, gyroscopeValues, userAccelerometerValues) {
        // 상태 갱신이 필요하지 않으므로 setState 호출 생략
      });

      if (_interpreter != null) {
        print("운동 감지 시작...");
        startMovementDetection(
          _interpreter!,
          predict,
              (int predictedMaxIndex) {
            if (predictedMaxIndex != prevMaxIndex) {
              setState(() {
                maxIndex = predictedMaxIndex;
                activity = getActivityText(maxIndex);
                prevMaxIndex = predictedMaxIndex;
              });
            }
          },
              () {
            // 상태 갱신이 필요하지 않으므로 setState 호출 생략
          },
        );
      }
    } catch (e) {
      print("모델 또는 센서 초기화 중 오류 발생: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.sensors,
      Permission.activityRecognition,
      Permission.bluetooth,
    ].request();

    statuses.forEach((permission, status) {
      print('$permission: $status');
      if (!status.isGranted) {
        throw Exception('${permission.toString()} permission is not granted');
      }
    });
  }

  @override
  void dispose() {
    disposeSensorManagement();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return GetMaterialApp(  // GetMaterialApp 사용
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GetMaterialApp(  // GetMaterialApp 사용
      debugShowCheckedModeBanner: false,
      title: 'GIUT_GIOT',
      home: _isLoggedIn ? PageSlide() : LoginPage(),
      routes: {
        '/settings': (context) => const SettingScreen(),
        '/voice_activation': (context) => VoiceActivationScreen(),
      },
    );
  }
}
