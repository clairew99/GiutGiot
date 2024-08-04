import 'package:flutter/material.dart';

import '../screen_build/s_calendar.build.dart';
// import '../widget/w_calendar.build.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const CalendarContent(),
    );
  }
}
