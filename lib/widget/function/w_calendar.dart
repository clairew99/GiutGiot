import 'dart:developer';

import 'package:GIUTGIOT/utils/clothes/controller/clothes_controller.dart';
import 'package:GIUTGIOT/utils/clothes/dto/response_select_clothes_dto.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../function/clothes_calendar_widget.dart'; // 올바른 경로로 수정

// 상세 정보 위젯 생성 - 정진영(24.08.14)
import '../function/selected_clothes_display.dart';

// 2주간의 날짜를 표시하는 캘린더 위젯
class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜를 저장 (2주 범위 변경)
  DateTime _today = DateTime.now(); // 오늘 날짜
  DateTime? _clickedDate; // 클릭된 날짜
  DateTime? _highlightedDate; // 클릭 후 강조된 날짜
  final clothesController = Get.find<ClothesController>();

  // 주어진 날짜 기준으로 2주간의 날짜 목록 생성
  List<DateTime> _getDatesForTwoWeeks(DateTime baseDate) {
    List<DateTime> dates = [];
    DateTime startDate = baseDate.subtract(
        Duration(days: baseDate.weekday % 7));
    for (int i = 0; i < 14; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }

  // 현재 표시된 날짜보다 2주 전으로 이동
  Future<void> _previousTwoWeeks() async {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 14));
      clothesController.setBaseDate(_selectedDate);
    });
    await clothesController.getCurrentClothes(
        _selectedDate.add(Duration(days: 7)));
  }

  // 현재 표시된 날짜보다 2주 후로 이동
  Future<void> _nextTwoWeeks() async {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 14));
      clothesController.setBaseDate(_selectedDate);
    });
    await clothesController.getCurrentClothes(
        _selectedDate.add(Duration(days: 7)));
  }

  // 특정 날짜에 대한 위젯을 생성
  Widget _buildDateWidget(DateTime date) {
    bool isToday = date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;

    bool isHighlighted = _highlightedDate != null &&
        _highlightedDate!.year == date.year &&
        _highlightedDate!.month == date.month &&
        _highlightedDate!.day == date.day;

    // 날짜를 클릭했을 때의 동작
    return GestureDetector(
      onTap: () async {
        setState(() {
          _clickedDate = date;
          _highlightedDate = date;
        });

        // 선택한 날짜에 해당하는 옷 데이터를 서버에서 가져옴
        final selectedClothes = await clothesController.getSelectDayClothes(date);
        print('클릭한 날짜의 데이터를 불러옴: $selectedClothes');

        // 1초 후에 강조된 상태 해제
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            _highlightedDate = null; // 클릭된 상태를 초기화
          });
        });
      },

      child: Stack(
        alignment: Alignment.center,
        children: [
          // 모든 날짜에 대해 원을 표시
          Positioned(
            top: 35, // Y축을 조정하여 원의 위치를 조정
            child: Container(
              width: 50.0,
              height: 50.0, // 원의 크기
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday
                    ? Colors.purple[300]!.withOpacity(0.5)
                    : isHighlighted
                    ? Colors.grey.withOpacity(0.3) // 클릭 시 회색으로 강조
                    : Colors.white.withOpacity(0.4), // 일반 상태
              ),
            ),
          ),
          // ClothesCalendarWidget을 원 위에 배치
          Container(
            width: 40.0,
            height: 80.0,
            margin: EdgeInsets.all(4),
            alignment: Alignment.topCenter,
            child: ClothesCalendarWidget(date: date),
          ),
        ],
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
              DateFormat.yMMMM().format(_selectedDate.add(Duration(days: 6))),
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
                          DateFormat.E().format(DateTime(2022, 1, index + 2)),
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
        SizedBox(height: 30), // 캘린더와 데이터 표시 영역 사이의 간격
        Obx(() {
          if (clothesController.selectedClothes.isEmpty) {
            return Center(
              child: Text(''),
            );
          } else {
            final selectedClothes = clothesController.selectedClothes.first!;
            return SelectedClothes(selectedClothes: selectedClothes);
          }
        }),
      ],
    );
  }
}
