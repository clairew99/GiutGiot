import 'package:GIUTGIOT/utils/clothes/controller/clothes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final clothesController = Get.find<ClothesController>();
  @override
  void initState() {
    super.initState();
    _clothesDataFuture = _loadClothesData();
    _loadClothesForDate();
  }

  Future<Map<String, Map<String, dynamic>>> _loadClothesData() async {
    final response = await rootBundle.loadString('assets/today_clothes.json');
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response));
    // final List<dynamic> jsonData = json.decode(response);
    // print(response);
    return {
      for (var item in clothesController.currentClothes)
      // for (var item in jsonData)
        item!.date.toString(): {
          'topColor': item.topColor,
          'bottomColor': item.bottomColor,
          'pose': item.pose,
        }
    };
  }

  Future<void> _loadClothesForDate() async {
    final data = await _clothesDataFuture;
    String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
    String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? topColor = prefs.getString('selectedTopColor');
    String? bottomColor = prefs.getString('selectedBottomColor');

    setState(() {
      if (dateString == todayString && topColor != null && bottomColor != null) {
        // 오늘 날짜의 경우, SharedPreferences에 저장된 색상을 사용
        _clothes = {
          'topColor': topColor,
          'bottomColor': bottomColor,
          'pose': 'SITTING', // 임의로 설정한 값
        };
      } else {
        // 그 외의 날짜는 JSON 데이터를 사용
        _clothes = data[dateString];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
      var clothes = clothesController.currentClothes.firstWhere(
            (item) => item?.date.toString() == dateString,
        orElse: ()=> null,
      );

      String dateText = DateFormat.d().format(widget.date);
      final now = DateTime.now();
      if (clothes != null) {
        return CustomClothesWidget(
          topColor: _getColorCode(clothes.topColor!),
          bottomColor: _getColorCode(clothes.bottomColor!),
          dateText: dateText,
          pose: clothes.pose!, // 걷는 시간 데이터가 없다면 임의의 값 설정
        );
      } else if(widget.date.year == now.year&& widget.date.month == now.month && widget.date.day == now.day && clothesController.selectedTopColor != "") {
        return CustomClothesWidget(
          topColor: _getColorCode(clothesController.selectedTopColor.value),
          bottomColor: _getColorCode(clothesController.selectedBottomColor.value),
          dateText: dateText,
          pose: 'SITTING', // 걷는 시간 데이터가 없다면 임의의 값 설정
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
    });
  }
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<Map<String, Map<String, dynamic>>>(
  //     future: _clothesDataFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return SizedBox.shrink();
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else if (snapshot.hasData) {
  //         String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
  //         Map<String, dynamic>? clothes = _clothes ?? snapshot.data?[dateString];
  //
  //         String dateText = DateFormat.d().format(widget.date);
  //
  //         if (clothes != null) {
  //           return CustomClothesWidget(
  //             topColor: _getColorCode(clothes['topColor']!),
  //             bottomColor: _getColorCode(clothes['bottomColor']!),
  //             dateText: dateText,
  //             walkingTime: clothes['walkingTime']!,
  //             onPress: _loadClothesData
  //       );
  //
  //
  //         } else {
  //           return Text(
  //             dateText,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: Colors.black,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           );
  //         }
  //       } else {
  //         return SizedBox.shrink();
  //       }
  //     },
  //   );
  // }

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
      case 'IVORY':
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
