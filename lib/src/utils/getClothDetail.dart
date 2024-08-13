import '../../../Dio/api_service.dart';
import '../../../Dio/access_token_manager.dart';

class GetClothDetail {
  final ApiService apiService = ApiService();
  final int clothId; // clothId를 매개변수로 받습니다.

  GetClothDetail({required this.clothId});

  Future<Map<String, dynamic>?> fetchClothesDetail() async {
    String? token = await AccessTokenManager.getAccessToken();
    if (token == null) {
      print('Access token is missing');
      return null;
    }

    // print('Loading...');
    var response = await apiService.fetchClothesDetail(clothId.toString(), token);
    if (response != null) {
      print('Response received: $response');
    } else {
      print('Failed to get response');
    }
    return response;
  }
}
