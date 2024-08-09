class Config {
  // API 베이스 URL
  static const String baseUrl = 'http://i11a409.p.ssafy.io:8080';

  // 타임아웃 설정
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // 엔드포인트 경로들
  static const String conversationEndpoint = '/conversation';
  static const String clothesEndpoint = '/clothes';
  static const String authEndpoint = '/auth/login?memberId=1';

  // 전송할 URI 생성 메서드
  static Uri getConversationUri() => Uri.parse('$baseUrl$conversationEndpoint');
  static Uri getClothesUri(String clothesId) => Uri.parse('$baseUrl$clothesEndpoint/$clothesId');
  static Uri getAuthUri() => Uri.parse('$baseUrl$authEndpoint');
}
