import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'w_cloth_item.dart';
import '../../storage.dart'; // storage.dart 파일 import

class ClothLoader {
  final String jsonFilePath;

  ClothLoader(this.jsonFilePath);

  static final Map<String, List<ClothItem>> _cachedData = {}; // 캐시된 데이터를 저장할 정적 변수

  Future<void> loadClothItems() async {
    try {
      if (_cachedData.containsKey(jsonFilePath)) {
        _storeClothPaths(_cachedData[jsonFilePath]!); // 캐시된 데이터를 전역 변수에 저장
      } else {
        final jsonString = await rootBundle.loadString(jsonFilePath);

        // 주석 처리 완료 - 정진영 (24.08.09)
        // print('JSON String Loaded: $jsonString'); // JSON 파일 로드 확인
        final List<dynamic> jsonList = json.decode(jsonString);
        // print('JSON Decoded: $jsonList'); // JSON 디코드 확인
        final List<ClothItem> items = jsonList.map((data) => ClothItem.fromJson(data)).toList();
        _cachedData[jsonFilePath] = items; // 캐시에 데이터 저장
        _storeClothPaths(items); // 전역 변수에 저장
      }
      // print('Cloth Items Loaded: ${clothPaths.toString()}'); // 최종 로드된 clothPaths 확인
    } catch (e) {
      print('Error loading cloth items: $e');
    }
  }
  void _storeClothPaths(List<ClothItem> items) {
    // HomeClothPaths를 초기화합니다.
    HomeClothPaths = {
      'remembered': [],
      'forgotten': []
    };

    // field 값 기준으로 오름차순 정렬
    // 기억 가중치로 분류하기 ( 20% 이하를 떨어 트릴 수 있도록 조정 )
    // 정진영 (24.08.09)


    for (var item in items) {
      if (item.field <= 0.2) {
        HomeClothPaths['forgotten']?.add(item.clothPath);
        HomeClothPaths['forgotten']?.add(item.field);
      } else {
        HomeClothPaths['remembered']?.add(item.clothPath);
        HomeClothPaths['remembered']?.add(item.field);
      }
    }
  }
}

