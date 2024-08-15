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

  const ClothesCalendarWidget({super.key, required this.date});

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
    // _clothesDataFuture 초기화
    _clothesDataFuture = _loadClothesData();  // 이 부분을 추가합니다.
    _loadClothesForDate();
    print('##################');
    print(clothesController.currentClothes);
  }

  Future<Map<String, Map<String, dynamic>>> _loadClothesData() async {
    // 예시로 로컬 JSON 파일에서 데이터를 로드하는 방법입니다.
    // 실제로는 원하는 데이터 소스에 맞게 수정하세요.
    String jsonString = await rootBundle.loadString('assets/clothes_data.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));
  }

  Future<void> _loadClothesForDate() async {
    final data = await _clothesDataFuture;  // 이 부분이 초기화되지 않으면 에러가 발생합니다.
    String dateString = DateFormat('yyyy-MM-dd').format(widget.date);
    String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? topColor = prefs.getString('selectedTopColor');
    String? bottomColor = prefs.getString('selectedBottomColor');

    setState(() {
      if (dateString == todayString && topColor != null && bottomColor != null) {
        _clothes = {
          'topColor': topColor,
          'bottomColor': bottomColor,
          'pose': 'SITTING',
        };
      } else {
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
        orElse: () => null,
      );

      String dateText = DateFormat.d().format(widget.date);
      final now = DateTime.now();
      if (clothes != null) {
        return CustomClothesWidget(
          topColor: _getColorCode(clothes.topColor!),
          bottomColor: _getColorCode(clothes.bottomColor!),
          dateText: dateText,
          pose: clothes.pose!,
        );
      } else if (widget.date.year == now.year && widget.date.month == now.month && widget.date.day == now.day && clothesController.selectedTopColor != "") {
        return CustomClothesWidget(
          topColor: _getColorCode(clothesController.selectedTopColor.value),
          bottomColor: _getColorCode(clothesController.selectedBottomColor.value),
          dateText: dateText,
          pose: 'SITTING',
        );
      } else {
        return Text(
          dateText,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    });
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
      case 'IVORY':
        return '#FFFFF0';
      case 'GREEN':
        return '#008000';
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
      case 'BLUE':
        return '#2C0EC2';
      default:
        return '#000000';
    }
  }
}
