import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenManager {
  static final _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  // 액세스 토큰 저장
  static Future<void> setAccessToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  // 리프레시 토큰 저장
  static Future<void> setRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // 액세스 토큰 불러오기
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // 리프레시 토큰 불러오기
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // 토큰 삭제 (로그아웃 시 사용)
  static Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // 토큰 유효성 확인
  static Future<bool> hasValidToken() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }
}
