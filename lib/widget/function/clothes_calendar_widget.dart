import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'custom_clothes.dart';

class ClothesCalendarWidget extends StatefulWidget {
  final DateTime date;

  ClothesCalendarWidget({required this.date});

  @override
  _ClothesCalendarWidgetState createState() => _ClothesCalendarWidgetState();
}

class _ClothesCalendarWidgetState extends State<ClothesCalendarWidget> {
  late Future<Map<String, Map<String, String>>> _clothesDataFuture;
  Map<String, String>? _clothes;        // 선택된 날짜의 옷 데이터를 저장하는 맵

  @override
  void initState() {
    super.initState();
    // clothesDataFuture는 _loadClothesData 메서드를 호출JSON해
    // 파일에서 옷 데이터를 로드함
    _clothesDataFuture = _loadClothesData();
    // 지정된 날짜에 대한 옷 데이터를 로드하여 _clothes 변수에 저장
    _loadClothesForDate();
  }

  Future<Map<String, Map<String, String>>> _loadClothesData() async {
    final String response = await rootBundle.loadString('assets/today_clothes.json');
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response));
    return {
      for (var item in data)
        // 날짜를 키로 상의 색상과 하의 색상을 값으로 가지는 맵
        item['date']: {
          'topColor': item['topColor'],
          'bottomColor': item['bottomColor']
        }
    };
  }

  void _loadClothesForDate() async {
    final data = await _clothesDataFuture;
    String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
    setState(() {
      // 지정된 날짜에 대한 옷 데이터를 _clothes 변수에 저장
      _clothes = data[dateString];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Map<String, String>>>(
      future: _clothesDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
          Map<String, String>? clothes = snapshot.data?[dateString];

          String dateText = DateFormat.d().format(widget.date);

          if (clothes != null) {
            return CustomClothesWidget(
              topColor: _getColorCode(clothes['topColor']!),
              bottomColor: _getColorCode(clothes['bottomColor']!),
              dateText: dateText,
            );
          } else {
            return Text(
              dateText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          }
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  String _getColorCode(String colorName) {
    switch (colorName.toUpperCase()) {
      case 'BLACK':
        return '#000000';
      case 'WHITE':
        return '#FFFFFF';
      case 'RED':
        return '#FF0000';
      case 'BLUE':
        return '#0000FF';
      case 'GREEN':
        return '#00FF00';
      case 'YELLOW':
        return '#FFFF00';
      case 'PINK':
        return '#FFC0CB';
      case 'GRAY':
        return '#808080';
      case 'ORANGE':
        return '#FFA500';
      default:
        return '#000000'; // 기본값
    }
  }
}
