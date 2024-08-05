import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/sensor_management.dart';
import 'screen/s_home.dart';
import 'screen/s_setting.dart';
import 'screen/s_voice_activation.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _requestPermissions();
      await setupSensorManagement();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing app: $e');
      // 에러 처리 로직 추가
    }
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
      Permission.sensors,
      Permission.activityRecognition,
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
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'GIUT_GIOT',
      home: const HomeScreen(),
      routes: {
        '/settings': (context) => const SettingScreen(),
        '/voice_activation': (context) => VoiceActivationScreen(),
      },
    );
  }
}
