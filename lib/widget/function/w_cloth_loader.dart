// w_cloth_loader.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'w_cloth_item.dart';

// 캐싱 메커니즘 구현 - 정진영 (24.08.05)


class ClothLoader extends StatefulWidget {
  final String jsonFilePath;
  final Widget Function(BuildContext, List<ClothItem>) builder;

  const ClothLoader({
    Key? key,
    required this.jsonFilePath,
    required this.builder,
  }) : super(key: key);

  @override
  _ClothLoaderState createState() => _ClothLoaderState();
}

class _ClothLoaderState extends State<ClothLoader> {
  static Map<String, List<ClothItem>> _cachedData = {}; // 캐시된 데이터를 저장할 정적 변수
  late Future<List<ClothItem>> _clothItems;

  @override
  void initState() {
    super.initState();
    if (_cachedData.containsKey(widget.jsonFilePath)) {
      // 캐시에 데이터가 있는 경우 캐시된 데이터를 사용
      _clothItems = Future.value(_cachedData[widget.jsonFilePath]);
    } else {
      // 캐시에 데이터가 없는 경우 새로 로드
      _clothItems = _loadClothItems();
    }
  }

  Future<List<ClothItem>> _loadClothItems() async {
    final jsonString = await rootBundle.loadString(widget.jsonFilePath);
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<ClothItem> items = jsonList.map((data) => ClothItem.fromJson(data)).toList();
    _cachedData[widget.jsonFilePath] = items; // 캐시에 데이터 저장
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClothItem>>(
      future: _clothItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 데이터를 로드 중일 때 로딩 표시
        } else if (snapshot.hasError) {
          print('Error loading cloth data: ${snapshot.error}');
          return Text('Error loading cloth data'); // 데이터 로드 중 오류 발생 시 메시지 표시
        } else if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!); // 데이터 로드 완료 시 builder 호출
        } else {
          return Text('No data found'); // 데이터가 없을 때 메시지 표시
        }
      },
    );
  }
}
