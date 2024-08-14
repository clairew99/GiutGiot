class Config {
  // API 베이스 URL
  static const String baseUrl = 'https://i11a409.p.ssafy.io:8443';

  // 타임아웃 설정
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // 엔드포인트 경로들
  static const String speakeranalysisEndpoint = '/pyannote';
  static const String conversationEndpoint = '/conversation';
  static const String clothesEndpoint = '/clothes';
  static const String coordinateEndpoint = '/coordinates';
  // static const String authEndpoint = '/auth/login?memberId=1';

  // 전송할 URI 생성 메서드
  static Uri getpyannoteUri() => Uri.parse('$FlaskbaseUrl$speakeranalysisEndpoint');
  static Uri getConversationUri() => Uri.parse('$FlaskbaseUrl$conversationEndpoint');
  static Uri getClothesUri(String clothesId) => Uri.parse('$baseUrl$clothesEndpoint/$clothesId');
  static Uri getClothesCheckUri() => Uri.parse('$baseUrl$clothesEndpoint/check');
  static Uri getMonthlyCoordinateUri(String year, String month, String day) =>
      Uri.parse('$baseUrl$coordinateEndpoint?year=$year&month=$month&day=$day');
  // static Uri getAuthUri() => Uri.parse('$baseUrl$authEndpoint');
}
