// cloth_loader.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'w_cloth_item.dart';

class ClothLoader extends StatefulWidget {
  final String jsonFilePath;
  final Widget Function(BuildContext, ClothItem) builder;

  const ClothLoader({
    Key? key,
    required this.jsonFilePath,
    required this.builder,
  }) : super(key: key);

  @override
  _ClothLoaderState createState() => _ClothLoaderState();
}

class _ClothLoaderState extends State<ClothLoader> {
  late Future<ClothItem> _clothItem;

  @override
  void initState() {
    super.initState();
    _clothItem = _loadClothItem();
  }

  Future<ClothItem> _loadClothItem() async {
    final jsonString = await rootBundle.loadString(widget.jsonFilePath);
    final List<dynamic> jsonList = json.decode(jsonString);
    final Map<String, dynamic> data = jsonList.first;
    return ClothItem.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClothItem>(
      future: _clothItem,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print('Error loading cloth data: ${snapshot.error}');
          return Text('Error loading cloth data');
        } else if (snapshot.hasData) {
          return widget.builder(context, snapshot.data!);
        } else {
          return Text('No data found');
        }
      },
    );
  }
}
