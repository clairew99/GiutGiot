import 'dart:convert';        // JSON 데이터의 인코딩 및 디코딩을 위해 사용
import 'package:flutter/services.dart';   // async와 await를 사용해 비동기 로딩을 처리


// ClothesService 클래스: 옷 데이터 로딩 담당
// 필요한 데이터들 해당 날짜에 입은 상하의 색깔을 문자열 형태로 불러오는 기능을 수행
class ClothesService {
  // Future: 비동기 작업의 완료 또는 실패를 나타냄
  // 외부 Map 키: 날짜를 나타내는 문자열
  // 내부 Map의 키: 'topColor'와 'bottomColor'. 각각의 값은 의류 색상을 나타내는 문자열
  Future<Map<String, Map<String, String>>> loadClothesData() async {

    // 비동기 작업 시작
    // rootBundle: today_clothes.json 파일의 내용 비동기적으로 로드
    // loadString: 파일의 내용을 문자열로 반환
    // await: 이 비동기 작업이 완료될 때까지 기다림
    final String response = await rootBundle.loadString('assets/today_clothes.json');
    // JSON 문자열을 Dart 객체로 디코딩. List<Map<String, dynamic>> 형태
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response));
    return {
      for (var item in data)
        // 외부 'Map'의 키 : 옷 데이터가 기록된 날짜
        item['date']: {
          'topColor': item['topColor'],     // 내부 'Map'의 키: 해당 날짜의 상하의 색상
          'bottomColor': item['bottomColor']
        }
    };
  }
}
