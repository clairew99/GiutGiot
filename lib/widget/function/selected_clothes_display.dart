import 'package:flutter/material.dart';
import 'package:GIUTGIOT/utils/clothes/dto/response_select_clothes_dto.dart';

class SelectedClothes extends StatelessWidget {
  final ResponseSelectDayClothesDto selectedClothes;

  const SelectedClothes({Key? key, required this.selectedClothes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 세로로 중앙에 배치
      crossAxisAlignment: CrossAxisAlignment.center, // 가로로 중앙에 배치
      children: [
        // 상의 부분
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 세로로 정렬
          children: [
            SizedBox(width: 30),
            Stack(
              alignment: Alignment.center, // 이미지들을 중앙에 정렬
              children: [
                Image.asset('assets/icon/marble.png',
                width:200,
                height: 200
              ),
                Image.asset(
                'assets/images/clothes/TOP_${selectedClothes.topCategory}_${selectedClothes.topType}_${selectedClothes.topPattern}_${selectedClothes.topColor}.png',
                width:100,
                height: 100,
              ),]
            ),
            // 상의 텍스트

            SizedBox(width: 20), // 상의 텍스트와 정보 사이의 간격 추가
            // 상의 상세 정보
            Column(

              // crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
              children: [
                Text(' ${selectedClothes.topType}', style: TextStyle(fontSize: 16)),
                Text(' ${selectedClothes.topCategory}', style: TextStyle(fontSize: 16)),
                Text('${selectedClothes.topColor}', style: TextStyle(fontSize: 16)),
                Text(' ${selectedClothes.topPattern}', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
        // SizedBox(height: 20), // 상의와 하의 사이에 간격 추가
        // 하의 부분
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 세로로 정렬
          children: [
            SizedBox(width: 30),
            Stack(
                alignment: Alignment.center, // 이미지들을 중앙에 정렬
              children: [
                Image.asset('assets/icon/marble.png',
                    width:200,
                    height: 200
                ),
                Image.asset(
                'assets/images/clothes/BOTTOM_${selectedClothes.bottomCategory}_${selectedClothes.bottomType}_${selectedClothes.bottomPattern}_${selectedClothes.bottomColor}.png',
                width:100,
                height: 100,
              ),]
            ),
            SizedBox(width: 20), // 하의 텍스트와 정보 사이의 간격 추가
            // 하의 상세 정보
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
              children: [
                Text(' ${selectedClothes.bottomType}', style: TextStyle(fontSize: 16)),
                Text(' ${selectedClothes.bottomCategory}', style: TextStyle(fontSize: 16)),
                Text('${selectedClothes.bottomColor}', style: TextStyle(fontSize: 16)),
                Text(' ${selectedClothes.bottomPattern}', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ],
    );

  }
}
