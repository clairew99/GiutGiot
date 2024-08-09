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
  late Future<Map<String, Map<String, dynamic>>> _clothesDataFuture;
  Map<String, dynamic>? _clothes;

  @override
  void initState() {
    super.initState();
    _clothesDataFuture = _loadClothesData();
    _loadClothesForDate();
  }

  Future<Map<String, Map<String, dynamic>>> _loadClothesData() async {
    final String response = await rootBundle.loadString('assets/today_clothes.json');
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response));
    return {
      for (var item in data)
        item['date']: {
          'topColor': item['topColor'],
          'bottomColor': item['bottomColor'],
          'walkingTime': item['walkingTime'],
        }
    };
  }

  void _loadClothesForDate() async {
    final data = await _clothesDataFuture;
    String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
    setState(() {
      _clothes = data[dateString];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Map<String, dynamic>>>(
      future: _clothesDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
          Map<String, dynamic>? clothes = snapshot.data?[dateString];

          String dateText = DateFormat.d().format(widget.date);

          if (clothes != null) {
            return CustomClothesWidget(
              topColor: _getColorCode(clothes['topColor']!),
              bottomColor: _getColorCode(clothes['bottomColor']!),
              dateText: dateText,
              walkingTime: clothes['walkingTime']!,
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
      case 'YELLOW':
        return '#FFFF00';
      case 'PINK':
        return '#FFC0CB';
      case 'GRAY':
        return '#808080';
      case 'ORANGE':
        return '#FFA500';
      case 'IYORY':
        return '#FFFFF0';
      case 'KHAKI':
        return '#63C284';
      case 'LIGHT BLUE':
        return '#B6F7FA';
      case 'SKY BLUE':
        return '#87CEEB';
      case 'NAVY':
        return '#000080';
      case 'PURPLE':
        return '#800080';
      case 'BROWN':
        return '#A52A2A';
      default:
        return '#000000';
    }
  }
}
