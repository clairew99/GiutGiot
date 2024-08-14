import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class MemoryDetailContent extends StatefulWidget {
  @override
  _MemoryDetailContentState createState() => _MemoryDetailContentState();
}

class _MemoryDetailContentState extends State<MemoryDetailContent> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 600, // PageView 높이 설정
      child: PageView.builder(
        controller: _pageController,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Opacity(
            opacity: _currentPage == index ? 1.0 : 0.5, // 현재 카드가 아닌 카드들을 흐리게
            child: _buildCard(index),
          );
        },
      ),
    );
  }

  Widget _buildCard(int index) {
    switch (index) {
      case 0:
        return _buildCardContainer(_buildFirstCard());
      case 1:
        return _buildCardContainer(_buildSecondCard());

      default:
        return Container();
    }
  }

  Widget _buildCardContainer(Widget child) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: 700, // 통일된 높이 설정
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
            ),
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildFirstCard() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
              alignment: Alignment.center,
              children: [
                Container(
                width: 200, // 원형 배경의 지름
                height: 200, // 원형 배경의 지름
                decoration: BoxDecoration(
                  color: Colors.white, // 하얀색 배경
                  shape: BoxShape.circle, // 원형 모양으로 설정
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // 그림자 색상
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // 그림자의 위치
                    ),
                  ],
                ),
              ),
                ClipOval(
                  child: Image.asset('assets/images/icons/chart_memory.gif',
                    fit: BoxFit.cover, // 이미지가 원형을 채우도록 설정
                    width: 200,
                    height: 200,),
                )]
          ),
          SizedBox(height: 20,),
          Text(
            '색상과 대화 길이 정보를 기반으로 ‘기억도’를 측정합니다.',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20,),
          Text(
            '이 기억도는 에빙하우스의 망각 곡선을 적용하여, 특정 옷차림이 사람들의 기억 속에서 언제쯤 희미해질지 예측합니다.',
            style: TextStyle(fontSize: 12),
          ),

        ],
      ),
    );
  }

  Widget _buildSecondCard() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
              alignment: Alignment.center,
              children: [Container(
                width: 200, // 원형 배경의 지름
                height: 200, // 원형 배경의 지름
                decoration: BoxDecoration(
                  color: Colors.white, // 하얀색 배경
                  shape: BoxShape.circle, // 원형 모양으로 설정
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // 그림자 색상
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // 그림자의 위치
                    ),
                  ],
                ),
              ),
                Container(
                  child: Image.asset('assets/images/icons/memory.gif',
                    fit: BoxFit.cover, // 이미지가 원형을 채우도록 설정
                    width: 200,
                    height: 200,),
                )]
          ),
          SizedBox(height: 20,),
          Text(
            '옷에 대한‘기억도’를 알 수 있습니다!',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          Container(
            margin: EdgeInsets.all(10), // Container로 margin 설정
            child: Column(
              children: [
                Text(
                  '이러한 정보를 바탕으로 옷을 입은 날을 기준으로 며칠이 지나야지\n'
                      '사람들의 기억 속에서 잊혀지는지 알려드려요!',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),

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
        ],
      ),
    );
  }

}
