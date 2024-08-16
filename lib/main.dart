import 'package:GIUTGIOT/utils/clothes/controller/clothes_controller.dart';
import 'package:flutter/material.dart';
import 'app.dart';  // MyApp 클래스를 불러오는 파일
import 'dart:io';  // HttpOverrides 클래스 사용을 위해 추가
import 'package:flutter/foundation.dart';  // kDebugMode 사용을 위해 추가
import 'Dio/access_token_manager.dart';  // AccessTokenManager 클래스를 불러오는 파일
import 'package:get/get.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){  // '?'를 추가해서 null safety 확보
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  Get.put(ClothesController());
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // 디버그 모드에서 토큰을 초기화
  if (kDebugMode) {
    //await AccessTokenManager.deleteTokens();  // clearTokens 대신 deleteTokens 메서드를 사용합니다.
  }

  runApp(MyApp());
}
