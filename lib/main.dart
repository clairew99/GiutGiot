import 'package:GIUTGIOT/utils/clothes/controller/clothes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'widget/function/w_cloth_loader.dart';
import 'storage.dart';
import 'dart:io' ;

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){  // '?'를 추가해서 null safety 확보
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ClothLoader('assets/test.json').loadClothItems(); // 앱 실행 시 데이터 로드
  await Get.put(ClothesController());
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}