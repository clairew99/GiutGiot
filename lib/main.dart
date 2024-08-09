import 'package:flutter/material.dart';
import 'app.dart';
import 'widget/function/w_cloth_loader.dart';
import 'storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ClothLoader('assets/test.json').loadClothItems(); // 앱 실행 시 데이터 로드
  runApp(MyApp());
}