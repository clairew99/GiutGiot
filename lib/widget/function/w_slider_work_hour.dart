// work_hour_slider.dart
import 'package:flutter/material.dart';

// 데이터 CRUD 구현 X - 정진영 (24.08.04)


class WorkHourSlider extends StatefulWidget {
  final RangeValues initialWorkHours;
  final ValueChanged<RangeValues> onWorkHoursChanged;

  const WorkHourSlider({
    Key? key,
    required this.initialWorkHours,
    required this.onWorkHoursChanged,
  }) : super(key: key);

  @override
  _WorkHourSliderState createState() => _WorkHourSliderState();
}

class _WorkHourSliderState extends State<WorkHourSlider> {
  late RangeValues _currentWorkHours;

  @override
  void initState() {
    super.initState();
    _currentWorkHours = widget.initialWorkHours;
  }

  void _onSliderChanged(RangeValues newValues) {
    setState(() {
      _currentWorkHours = newValues;
    });
    widget.onWorkHoursChanged(newValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        RangeSlider(
          values: _currentWorkHours,
          min: 0,
          max: 24,
          divisions: 24,
          labels: RangeLabels(
            '${_currentWorkHours.start.round()}시',
            '${_currentWorkHours.end.round()}시',
          ),
          onChanged: _onSliderChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 출근 시간 및 아이콘
            Column(
              children: [
                Icon(Icons.directions_run, size: 22, color: Colors.black),
                SizedBox(height: 4),
                Text('${_currentWorkHours.start.round()}:00', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(width: 20), // 출근과 퇴근 시간 사이 간격
            Icon(Icons.arrow_forward, size: 24, color: Colors.black), // 화살표 아이콘
            SizedBox(width: 20), // 화살표와 퇴근 시간 사이 간격
            // 퇴근 시간 및 아이콘
            Column(
              children: [
                Icon(Icons.home, size: 22, color: Colors.black),
                SizedBox(height: 4),
                Text('${_currentWorkHours.end.round()}:00', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        )



      ],
    );
  }
}
