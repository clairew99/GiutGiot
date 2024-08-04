import 'package:flutter/material.dart';
import '../screen_build/s_calendar.build.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: const CalendarContent(),
    );
  }
}
