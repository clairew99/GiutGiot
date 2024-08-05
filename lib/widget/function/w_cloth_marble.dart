// cloth_marble.dart
import 'package:flutter/material.dart';
import 'w_cloth_loader.dart'; // ClothLoader 위젯을 불러오는 경로

class ClothMarble extends StatelessWidget {
  final String marbleImagePath;
  final String jsonFilePath;

  const ClothMarble({
    Key? key,
    this.marbleImagePath = "assets/icon/marble.png",
    required this.jsonFilePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClothLoader(
      jsonFilePath: jsonFilePath,
      builder: (context, clothItem) {
        // clothItem을 이용해 이미지 경로를 생성
        final clothImagePath = 'assets/clothes/${clothItem.isTop ? "top" : "bottom"}_${clothItem.category}_${clothItem.type}_${clothItem.pattern}_${clothItem.color}.png';
        print('output: ${clothImagePath}');
        return Stack(
          alignment: Alignment.center,
          children: [
            // 구슬 이미지
            Image.asset(
              marbleImagePath,
              fit: BoxFit.cover, // 구슬 이미지를 전체 배경으로 설정
            ),
            // 옷 이미지
            FractionallySizedBox(
              widthFactor: 0.35, // 구슬 아이콘의 80% 너비로 설정
              heightFactor: 0.35, // 구슬 아이콘의 80% 높이로 설정
              child: Image.asset(
                clothImagePath,
                fit: BoxFit.contain, // 옷 이미지를 구슬 위에 맞추기
              ),
            ),
          ],
        );

      },
    );
  }
}
