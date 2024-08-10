import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiService {
  // 1. 새 옷 등록 API - POST
  Future<Map<String, dynamic>?> registerClothes(Map<String, dynamic> clothesData, String token) async {
    final uri = Uri.parse('${Config.baseUrl}${Config.clothesEndpoint}');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(clothesData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to register clothes: ${response.statusCode}');
      return null;
    }
  }

  // 2. 옷 착용 가능 여부 확인 API - POST
  Future<Map<String, dynamic>?> checkClothesAvailability(Map<String, dynamic> clothesData, String token) async {
    final uri = Uri.parse('${Config.baseUrl}${Config.clothesEndpoint}/check');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(clothesData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to check clothes availability: ${response.statusCode}');
      return null;
    }
  }

  // 3. 기억도별 옷 조회 API - GET
  Future<Map<String, dynamic>?> fetchClothesByMemory(String token) async {
    final uri = Uri.parse('${Config.baseUrl}${Config.clothesEndpoint}/memory');
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
      print('Failed to fetch clothes by memory: ${response.statusCode}');
      return null;
    }
  }

  // 4. 옷 예측 API - GET
  Future<Map<String, dynamic>?> fetchClothesPrediction(String token) async {
    final uri = Uri.parse('${Config.baseUrl}${Config.clothesEndpoint}/prediction');
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
      print('Failed to fetch clothes prediction: ${response.statusCode}');
      return null;
    }
  }

  // 5. 옷 상세조회 API - GET
  Future<Map<String, dynamic>?> fetchClothesDetail(String clothesId, String token) async {
    final uri = Config.getClothesUri(clothesId);
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
      print('Failed to fetch clothes detail: ${response.statusCode}');
      return null;
    }
  }

  // 6. 코디 월별 조회 API - GET
  Future<Map<String, dynamic>?> fetchMonthlyCoordinate(String year, String month, String day, String token) async {
    final uri = Uri.parse('${Config.baseUrl}${Config.coordinateEndpoint}?year=$year&month=$month&day=$day');
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
      print('Failed to fetch monthly coordinates: ${response.statusCode}');
      return null;
    }
  }

  // 7. 코디 등록 API - POST
  Future<Map<String, dynamic>?> registerCoordinate(Map<String, dynamic> coordinateData, String token) async {
    final uri = Uri.parse('${Config.baseUrl}${Config.coordinateEndpoint}');
    print('Sending request to: $uri');
    print('Request body: ${jsonEncode(coordinateData)}');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(coordinateData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to register coordinate: ${response.statusCode}');
      return null;
    }
  }

  // 8. 코디 수정 API - PATCH
  Future<Map<String, dynamic>?> updateCoordinate(Map<String, dynamic> coordinateData, String token) async {
    final uri = Uri.parse('${Config.baseUrl}${Config.coordinateEndpoint}');
    final response = await http.patch(
      uri,
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(coordinateData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to update coordinate: ${response.statusCode}');
      return null;
    }
  }

  // 9. 코디 일별 조회 API - GET
  Future<Map<String, dynamic>?> fetchDailyCoordinate(String year, String month, String day, String token) async {
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
}
