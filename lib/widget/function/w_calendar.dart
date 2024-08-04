import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  DateTime _today = DateTime.now();
  DateTime? _clickedDate;

  List<DateTime> _getDatesForTwoWeeks(DateTime baseDate) {
    List<DateTime> dates = [];
    // 현재 주의 첫 번째 날로 설정하고 한 주를 뺍니다.
    DateTime startDate = baseDate.subtract(Duration(days: baseDate.weekday + 6));
    for (int i = 0; i < 14; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  void _previousTwoWeeks() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 14));
    });
  }

  void _nextTwoWeeks() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 14));
    });
  }

  Widget _buildDateWidget(DateTime date) {
    bool isToday = date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;

    bool isSelected = _clickedDate != null &&
        date.year == _clickedDate!.year &&
        date.month == _clickedDate!.month &&
        date.day == _clickedDate!.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          _clickedDate = date;
        });
        // 1초 후에 선택 상태를 해제
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _clickedDate = null;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isToday
              ? Colors.purple[100]
              : isSelected
              ? Colors.purple[50]
              : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          DateFormat.d().format(date),
          style: TextStyle(
            color: isToday ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

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
                TableRow(
                  children: List.generate(7, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: Text(
                          DateFormat.E().format(DateTime(2022, 1, index + 3)),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 20), // 요일과 첫 번째 주 사이의 간격
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
            SizedBox(height: 70), // 첫 번째 주와 두 번째 주 사이의 간격
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
