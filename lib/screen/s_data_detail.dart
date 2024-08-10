import 'package:flutter/material.dart';
import '../Dio/api_service.dart';
import '../Dio/access_token_manager.dart';

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String _response = 'No response yet';
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  void _setResponse(String response) {
    setState(() {
      _response = response;
    });
  }

  Future<void> _executeApiCall(Function apiCall) async {
    String? token = await AccessTokenManager.getAccessToken();
    if (token == null) {
      _setResponse('Access token is missing');
      return;
    }

    _setResponse('Loading...');
    var response = await apiCall(token);
    _setResponse(response != null ? response.toString() : 'Failed to get response');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API 테스트'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Response:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Container(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Text(_response),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                _buildApiTestTile('1. 새 옷 등록', () {
                  Map<String, dynamic> clothesData = {
                    "isTop": true,
                    "color": "RED",
                    "type": "LONG",
                    "category": "HOODIE",
                    "pattern": "CHECK"
                  };
                  _executeApiCall((token) => apiService.registerClothes(clothesData, token));
                }),
                _buildApiTestTile('2. 옷 착용 가능 여부 확인', () {
                  Map<String, dynamic> clothesData = {
                    "isTop": true,
                    "color": "BLACK",
                    "type": "LONG",
                    "category": "SHIRT",
                    "pattern": "STRIPE"
                  };
                  _executeApiCall((token) => apiService.checkClothesAvailability(clothesData, token));
                }),
                _buildApiTestTile('3. 기억도별 옷 조회', () {
                  _executeApiCall((token) => apiService.fetchClothesByMemory(token));
                }),
                _buildApiTestTile('4. 옷 예측', () {
                  _executeApiCall((token) => apiService.fetchClothesPrediction(token));
                }),
                _buildApiTestTile('5. 옷 상세 조회', () {
                  _executeApiCall((token) => apiService.fetchClothesDetail('10001', token));
                }),
                _buildApiTestTile('6. 코디 월별 조회', () {
                  _executeApiCall((token) => apiService.fetchMonthlyCoordinate('2024', '08', '10', token));
                }),
                _buildApiTestTile('7. 코디 등록', () {
                  Map<String, dynamic> coordinateData = {
                    "topId": 10001,
                    "bottomId": 11001,
                    "date": "2024-08-01"
                  };
                  _executeApiCall((token) => apiService.registerCoordinate(coordinateData, token));
                }),
                _buildApiTestTile('8. 코디 수정', () {
                  Map<String, dynamic> coordinateData = {
                    "date": "2024-08-01",
                    "topColor": "BLACK",
                    "topCategory": "LONG",
                    "topType": "SHIRTS",
                    "topPattern": "CHECK",
                    "bottomColor": "BLACK",
                    "bottomCategory": "SHORT",
                    "bottomType": "PANTS",
                    "bottomPattern": "CHECK"
                  };
                  _executeApiCall((token) => apiService.updateCoordinate(coordinateData, token));
                }),
                _buildApiTestTile('9. 코디 일별 조회', () {
                  _executeApiCall((token) => apiService.fetchDailyCoordinate('2024', '08', '06', token));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiTestTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}