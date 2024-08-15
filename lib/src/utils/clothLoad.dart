import 'package:flutter/material.dart';
import '../../../Dio/api_service.dart';
import '../../../Dio/access_token_manager.dart';
import '../../storage.dart'; // storage.dart 파일 import

class ClothLoad {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>?> testFetchClothesByMemory() async {
    String? token = await AccessTokenManager.getAccessToken();
    if (token == null) {
      print('Access token is missing');
      return null;
    }

    var response = await apiService.fetchClothesByMemory(token);
    if (response != null) {
      print('success! HomeClothPath!!');
      _storeClothPaths(response); // 전역 변수에 저장
    } else {
      print('Failed to get response');
    }
    return response;
  }
}

void _storeClothPaths(Map<String, dynamic> response) {
  // HomeClothPaths를 초기화합니다.
  HomeClothPaths = {
    'forgotten': [],
    'remembered': [],
  };

  // forgottenClothesList와 rememberedClothesList 추출
  List<dynamic> forgottenClothesList = response['forgottenClothesList'];
  List<dynamic> rememberedClothesList = response['rememberedClothesList'];

  // 기억되지 않은 옷들을 임시 리스트에 추가
  List<List<dynamic>> forgottenTempList = [];
  for (var item in forgottenClothesList) {
    final temp_list = [];

    // Map<String, dynamic>에서 값을 추출하여 이미지 경로 생성
    bool isTop = item['isTop'];
    String category = item['category'];
    String type = item['type'];
    String pattern = item['pattern'];
    String color = item['color'];

    // 이미지 경로 생성
    String clothPath = 'clothes/${isTop ? "TOP" : "BOTTOM"}_${category}_${type}_${pattern}_${color}.png';

    // clothPath와 함께 다른 정보들을 리스트에 추가
    temp_list.add(item['clothesId']);
    temp_list.add(item['memory']);
    temp_list.add(clothPath);

    forgottenTempList.add(temp_list);
  }

  // 메모리 값 기준으로 오름차순 정렬
  forgottenTempList.sort((a, b) => a[1].compareTo(b[1]));

  // 정렬된 리스트를 HomeClothPaths에 추가
  HomeClothPaths['forgotten']?.addAll(forgottenTempList);

  // 기억된 옷들을 임시 리스트에 추가
  List<List<dynamic>> rememberedTempList = [];
  for (var item in rememberedClothesList) {
    final temp_list = [];

    // Map<String, dynamic>에서 값을 추출하여 이미지 경로 생성
    bool isTop = item['isTop'];
    String category = item['category'];
    String type = item['type'];
    String pattern = item['pattern'];
    String color = item['color'];

    // 이미지 경로 생성
    String clothPath = 'clothes/${isTop ? "TOP" : "BOTTOM"}_${category}_${type}_${pattern}_${color}.png';

    // clothPath와 함께 다른 정보들을 리스트에 추가
    temp_list.add(item['clothesId']);
    temp_list.add(item['memory']);
    temp_list.add(clothPath);

    rememberedTempList.add(temp_list);
  }

  // 메모리 값 기준으로 오름차순 정렬
  rememberedTempList.sort((a, b) => a[1].compareTo(b[1]));

  // 정렬된 리스트를 HomeClothPaths에 추가
  HomeClothPaths['remembered']?.addAll(rememberedTempList);
}
