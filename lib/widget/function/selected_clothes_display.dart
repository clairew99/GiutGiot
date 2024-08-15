import 'package:flutter/material.dart';
import 'package:GIUTGIOT/utils/clothes/dto/response_select_clothes_dto.dart';

class SelectedClothes extends StatelessWidget {
  final ResponseSelectDayClothesDto selectedClothes;

  const SelectedClothes({Key? key, required this.selectedClothes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(20, 0), // 전체를 오른쪽으로 20만큼 이동
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 세로로 중앙에 배치
        crossAxisAlignment: CrossAxisAlignment.center, // 가로로 중앙에 배치
        children: [
          // 상의 부분
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // 세로로 정렬
            children: [
              SizedBox(width: 10),
              Stack(
                alignment: Alignment.center, // 이미지들을 중앙에 정렬
                children: [
                  // 흰색 원을 먼저 배치하여 마블보다 뒤에 있도록 함
                  Transform.translate(
                    offset: Offset(120, 0), // 원과 텍스트를 함께 이동
                    child: Container(
                      width: 150, // 원의 크기
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // 그림자 색상 및 투명도
                            spreadRadius: 1, // 그림자 확산 반경
                            blurRadius: 1, // 그림자 흐림 정도
                            offset: Offset(0, 2), // 그림자의 위치 (X, Y)
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 마블 이미지
                  Image.asset(
                    'assets/icon/marble.png',
                    width: 200,
                    height: 200,
                  ),
                  // 상의 이미지
                  Image.asset(
                    'assets/images/clothes/TOP_${selectedClothes.topCategory}_${selectedClothes.topType}_${selectedClothes.topPattern}_${selectedClothes.topColor}.png',
                    width: 100,
                    height: 100,
                  ),
                  // 상의 상세 정보 텍스트
                  Transform.translate(
                    offset: Offset(120, 0), // 텍스트를 흰색 원과 동일하게 이동
                    child: Column(
                      children: [
                        Text(
                          ' ${selectedClothes.topType}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.7, // 줄 간격 설정
                          ),
                        ),
                        Text(
                          ' ${selectedClothes.topCategory}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                        Text(
                          '${selectedClothes.topColor}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                        Text(
                          ' ${selectedClothes.topPattern}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0, -20), // 하의 부분을 상의와 겹치도록 이동
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 세로로 정렬
              children: [
                SizedBox(width: 10),
                Stack(
                  alignment: Alignment.center, // 이미지들을 중앙에 정렬
                  children: [
                    // 흰색 원을 먼저 배치하여 마블보다 뒤에 있도록 함
                    Transform.translate(
                      offset: Offset(120, 0), // 원과 텍스트를 함께 이동
                      child: Container(
                        width: 150, // 원의 크기
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3), // 그림자 색상 및 투명도
                              spreadRadius: 1, // 그림자 확산 반경
                              blurRadius: 1, // 그림자 흐림 정도
                              offset: Offset(0, 2), // 그림자의 위치 (X, Y)
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 마블 이미지
                    Image.asset(
                      'assets/icon/marble.png',
                      width: 200,
                      height: 200,
                    ),
                    // 하의 이미지
                    Image.asset(
                      'assets/images/clothes/BOTTOM_${selectedClothes.bottomCategory}_${selectedClothes.bottomType}_${selectedClothes.bottomPattern}_${selectedClothes.bottomColor}.png',
                      width: 100,
                      height: 100,
                    ),
                    // 하의 상세 정보 텍스트
                    Transform.translate(
                      offset: Offset(120, 0), // 텍스트를 흰색 원과 동일하게 이동
                      child: Column(
                        children: [
                          Text(
                            ' ${selectedClothes.bottomType}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.7,
                            ),
                          ),
                          Text(
                            ' ${selectedClothes.bottomCategory}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.7,
                            ),
                          ),
                          Text(
                            '${selectedClothes.bottomColor}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.7,
                            ),
                          ),
                          Text(
                            ' ${selectedClothes.bottomPattern}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
