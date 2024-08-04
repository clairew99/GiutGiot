import 'package:flutter/material.dart';

import '../screen_build/s_setting_build.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SettingContent(),
    );
  }
}
