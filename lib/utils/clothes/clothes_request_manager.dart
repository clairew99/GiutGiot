import 'package:GIUTGIOT/Dio/access_token_manager.dart';
import 'package:GIUTGIOT/utils/clothes/dto/request_today_clothes_dto.dart';
import 'package:GIUTGIOT/utils/clothes/dto/response_select_clothes_dto.dart';
import 'package:GIUTGIOT/utils/clothes/dto/clothes_for_date.dart';
import 'package:GIUTGIOT/utils/clothes/dto/request_cloth_dto.dart';
import 'package:GIUTGIOT/utils/dio_singleton.dart';
import 'package:dio/dio.dart';
import '../../Dio/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Dio/api_service.dart';



Future<ClothesForMonth> getMonthlyClothes (DateTime date) async {
  String? token = await AccessTokenManager.getAccessToken();
  Dio dio = DioSingleton().dio;
  // 임시로그인 설정

  final response = await dio.get('/coordinates',queryParameters: {"year":date.year,"month":date.month,"day":date.day});
  final result = (ClothesForMonth.fromJson(response.data));
  return result;
}

// 옷의 정보를 담아서 옷 아이디를 받아오는 함수
Future<int> saveClothes (RequestClothesDto dto) async {
  Dio dio = DioSingleton().dio;
  final response = await dio.post('/clothes',data: dto.toJson());
  return response.data['clothesId'];
}

// 오늘 옷의 아이디들을 서버에 저장하는 함수
Future<void> saveTodayClothes (RequestTodayClothesDto dto) async {
  Dio dio = DioSingleton().dio;
  print(dto.toJson());
  final response = await dio.post('/coordinates',data: dto.toJson());
  print("######################${response.statusCode}");
}


// 9. 코디 일별 조회 API - GET
Future<Map<String, dynamic>?> fetchDailyCoordinate(DateTime date, String token) async {
  String year = date.year.toString() ;
  String month = date.month.toString() ;
  String day = date.day.toString();
  String? token = await AccessTokenManager.getAccessToken();


  final uri = Uri.parse('${Config.baseUrl}${Config.coordinateEndpoint}/daily?year=$year&month=$month&day=$day');

  final response = await http.get(
    uri,
    headers: {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Failed to fetch daily coordinates: ${response.statusCode}');
    return null;
  }

}


// 선택한 날의 상의, 하의 정보를 받아오는 함수
Future<ResponseSelectDayClothesDto> saveSelecteddayClothes (DateTime date) async {

  Dio dio = DioSingleton().dio;

  // URL에 날짜 정보를 year, month, day로 개별 쿼리 파라미터로 전송
  final queryParameters = {
    'year': date.year.toString(),
    'month': date.month.toString(),
    'day': date.day.toString(),
  };

  final response = await dio.get('/coordinates/daily', queryParameters: queryParameters);

  // JSON 데이터를 DTO로 변환하여 반환
  return ResponseSelectDayClothesDto.fromJson(response.data);
}

// dio 수정이다 이 자식아~
