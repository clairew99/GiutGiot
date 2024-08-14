import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'config.dart'; // config.dart 파일을 임포트

class AccessTokenManager {
  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';


  // AccessToken 저장
  static Future<void> setAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    print('Access token saved: $accessToken'); // 디버깅용 로그
  }

  // AccessToken 불러오기
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    print('Fetched access token: $token'); // 디버깅용 로그
    return token;
  }

  // RefreshToken 저장
  static Future<void> setRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
    print('Refresh token saved: $refreshToken'); // 디버깅용 로그
  }

  // RefreshToken 불러오기
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_refreshTokenKey);
    print('Fetched refresh token: $token'); // 디버깅용 로그
    return token;
  }

  // 로그인 요청 및 토큰 저장
  static Future<bool> fetchAndSaveToken() async {
    try {
      final dio = Dio();
      //final response = await dio.post(Config.getAuthUri().toString());
      print('${Config.baseUrl}/login/temp?memberId=1');

      print(dio.post('${Config.baseUrl}/auth/login?memberId=1')); // 임시 로그인
      final response = await dio.post('${Config.baseUrl}/login/temp?memberId=1'); // 임시 로그인
      // final response = await dio.post('${Config.baseUrl}/auth/login?memberId=1'); // 임시 로그인

      print('Login response: ${response.statusCode}'); // 디버깅용 로그

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('Login response data: $responseData'); // 디버깅용 로그

        // 응답 데이터에서 accessToken과 refreshToken 추출
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          print('Access token and refresh token found in response');
          await setAccessToken(accessToken);
          await setRefreshToken(refreshToken);
          return true;
        } else {
          print('Token keys not found in response data'); // 디버깅용 로그
        }
      } else {
        print('Failed to login, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching token: $e'); // 오류 로그
    }

    return false; // 토큰 가져오기 실패
  }

  // 토큰 초기화 (로그아웃 등)
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    print('Tokens cleared'); // 디버깅용 로그
  }
}

