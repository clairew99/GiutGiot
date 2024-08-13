import 'package:flutter/material.dart';
import 'app.dart';
import 'dart:io' ;
import 'src/utils/clothLoad.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){  // '?'를 추가해서 null safety 확보
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await ClothLoad().testFetchClothesByMemory();
  runApp(MyApp());
}

