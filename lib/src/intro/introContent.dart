import 'package:flutter/material.dart';
import 'dart:ui';

// 설명 DetailContent 위젯 임포트
import 'color_detail.dart';
import 'memory_detail.dart';
import 'conversation_detail.dart';


class Introcontent extends StatelessWidget {
  final String contentType;

  late String title ;


  // 생성자를 통해 contentType을 전달받음
  Introcontent({required this.contentType});

  @override
  Widget build(BuildContext context) {
    Widget content;

    // 조건문을 통해 어떤 위젯을 보여줄지 결정
    if (contentType == 'color') {
      content = ColorDetailContent();
      title = "옷의 색상";
    } else if (contentType == 'conversation') {
      content = ConversationDetailContent();
      title = "옷을 입고 나눈 대화";
    } else if (contentType == 'memory') {
      content = MemoryDetailContent();
      title = "옷에 관한 기억도";
    } else {
      content = Center(
        child: Text('유효하지 않은 컨텐츠 타입입니다.'),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent, // 기본 배경을 투명하게 설정
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // 블러 효과 추가
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: content, // 조건에 따라 결정된 위젯을 표시
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
