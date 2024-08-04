import 'package:flutter/material.dart';

class DescriptionService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기웃기옷'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '오늘 내가 입은 옷,\n언제 다시 입어도 될까?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "'기웃기옷'은 바쁜 현대인들을 위한 옷 분석 서비스입니다.  매일 아침, 오늘 입을 옷을 고민하는 시간을 줄여드립니다.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "기웃기옷은 오늘 입은 옷의 색상, 패턴, 종류 그리고 그 옷을 입고 만난 사람의 수와 대화량을 분석하여 옷이 사람들의 기억에 얼마나 남는지 가중치를 계산합니다.\n이를 바탕으로, 언제 다시 그 옷을 입어도 좋을지 알려드립니다.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "이제 옷 선택의 스트레스를 줄이고, 더 스마트하게 스타일을 관리하세요!",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
