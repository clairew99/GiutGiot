import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen_build/s_calendar.build.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String? _topColor;
  String? _bottomColor;

  @override
  void initState() {
    super.initState();
    _loadSelectedColors();
  }

  Future<void> _loadSelectedColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _topColor = prefs.getString('selectedTopColor') ?? 'default_top_color';
      _bottomColor = prefs.getString('selectedBottomColor') ?? 'default_bottom_color';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CalendarContent(),
    );
  }
}
