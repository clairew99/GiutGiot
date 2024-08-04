import 'package:flutter/material.dart';

import 'screen/s_home.dart';
import 'screen/s_setting.dart';
import 'screen/s_voice_activation.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIUT_GIOT',
      // 주 색상 설정하지 않음 (24.08.03)
      // theme: ThemeData(
      //   primarySwatch: Colors.white,
      // ),
      home: const HomeScreen(), // home 화면 처음 실행
      // router 설정
      routes: {
        '/settings': (context) => const SettingScreen(),
        '/voice_activation': (context) => VoiceActivationScreen(), // 여기를 수정
      },
    );
  }
}
