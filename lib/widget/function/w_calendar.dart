import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../function/clothes_calendar_widget.dart'; // 올바른 경로로 수정

// 2주간의 날짜를 표시하는 캘린더 위젯
class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜를 저장 (2주 범위 변경)
  DateTime _today = DateTime.now(); // 오늘 날짜
  DateTime? _clickedDate; // 클릭된 날짜

  // 주어진 날짜 기준으로 2주간의 날짜 목록 생성
  List<DateTime> _getDatesForTwoWeeks(DateTime baseDate) {
    List<DateTime> dates = [];
    DateTime startDate = baseDate.subtract(Duration(days: baseDate.weekday + 6));
    for (int i = 0; i < 14; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  // 현재 표시된 날짜보다 2주 전으로 이동
  void _previousTwoWeeks() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 14));
    });
  }

  // 현재 표시된 날짜보다 2주 후로 이동
  void _nextTwoWeeks() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 14));
    });
  }

  // 특정 날짜에 대한 위젯을 생성
  Widget _buildDateWidget(DateTime date) {
    bool isToday = date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;

    bool isSelected = _clickedDate != null &&
        date.year == _clickedDate!.year &&
        date.month == _clickedDate!.month &&
        date.day == _clickedDate!.day;

    // 날짜를 클릭했을 때의 동작
    return GestureDetector(
      onTap: () {
        setState(() {
          _clickedDate = date;
        });
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _clickedDate = null;
          });
        });
      },
      child: Container(
        width: 50.0,
        height: 80.0, // 높이를 늘려 숫자와 이미지를 분리
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isToday ? Colors.purple[200] : isSelected ? Colors.purple[50] : Colors.transparent,
        ),
        alignment: Alignment.topCenter, // 숫자를 상단에 배치
        child: ClothesCalendarWidget(date: date),
      ),
    );
  }

  // 캘린더 구성하는 전체 레이아웃
  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = _getDatesForTwoWeeks(_selectedDate);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: _previousTwoWeeks,
            ),
            Text(
              DateFormat.yMMMM().format(_selectedDate),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: _nextTwoWeeks,
            ),
          ],
        ),
        SizedBox(height: 30),
        Column(
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow( // 표의 한 행
                  children: List.generate(7, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: Text(
                          DateFormat.E().format(DateTime(2022, 1, index + 3)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: dates.getRange(0, 7).map((date) {
                    return _buildDateWidget(date);
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20), // 첫 번째 주와 두 번째 주 사이의 간격
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: dates.getRange(7, 14).map((date) {
                    return _buildDateWidget(date);
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
