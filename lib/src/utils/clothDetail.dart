import 'package:flutter/material.dart';
import '../utils/getClothDetail.dart'; // GetClothDetail 클래스를 가져옴
import 'ClothDetailContent.dart';
import 'dart:ui';
class ClothDetail extends StatelessWidget {
  final clothId;
  final String clothUrl;
  ClothDetail({required this.clothId, required this.clothUrl});

  @override
  Widget build(BuildContext context) {
    // FutureBuilder를 사용하여 데이터를 가져와서 표시
    return FutureBuilder<Map<String, dynamic>?>(
      future: GetClothDetail(clothId: clothId).fetchClothesDetail(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터를 불러오는 중일 때 로딩 스피너를 표시
          return AlertDialog(
            content: Container(
              width: 100,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(), // 로딩 스피너
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // 에러가 발생한 경우
          return AlertDialog(
            title: Text('Error'),
            content: Text('데이터 분석중 . . .'),
            actions: <Widget>[
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else if (snapshot.hasData) {
          // 데이터가 성공적으로 로드된 경우
          var data = snapshot.data!;
          return Dialog(
            backgroundColor: Colors.transparent, // 기본 배경을 투명하게 설정
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // 블러 효과 추가
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // 유리 같은 불투명한 배경
                  borderRadius: BorderRadius.circular(15.0), // 모서리를 둥글게 설정
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // 그림자 색상
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // 그림자의 위치
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      '상세 정보',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ClothDetailContent(
                        data: data,
                        clothUrl: clothUrl,
                      ),
                    ),
                    SizedBox(height: 16),
                    // 닫기 버튼 
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Dialog 닫기
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6, // 박스의 가로 크기
                          height: 40, // 박스의 세로 크기
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7), // 박스의 배경색
                            borderRadius: BorderRadius.circular(20), // 박스 모서리를 둥글게 설정
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // 그림자 색상
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2), // 그림자의 위치
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '닫기',
                              style: TextStyle(
                                color: Colors.black, // 텍스트 색상
                                fontSize: 16, // 텍스트 크기
                                fontWeight: FontWeight.w600, // 텍스트 굵기
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22),

                  ],
                ),
              ),
            ),
          );
        } else {
          // 데이터가 없는 경우
          return AlertDialog(
            title: Text('No Data ${clothId}'),
            content: Text('데이터 분석중 . . .'),
            actions: <Widget>[
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
}