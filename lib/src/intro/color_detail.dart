import 'package:flutter/material.dart';
import 'dart:ui';

class ColorDetailContent extends StatefulWidget {
  @override
  _ColorDetailContentState createState() => _ColorDetailContentState();
}

class _ColorDetailContentState extends State<ColorDetailContent> {
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
        itemCount: 3,
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
      case 2:
        return _buildCardContainer(_buildThirdCard());
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
                  child: Image.asset('assets/images/icons/cloth_color.png',
                    fit: BoxFit.cover, // 이미지가 원형을 채우도록 설정
                    width: 150,
                    height: 150,),
                )]
          ),
          SizedBox(height: 20,),
          Text(
            '저 사람 오늘 파란 니트를 입었네!',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20,),
          Text(
            '눈에 띄는 색상의 옷을 보면 기억에 \n더 오래 남은 기억이 있지 않으신가요? ',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 46,),

        ],
      ),
    );
  }

  Widget _buildSecondCard() {
    return Container(
      margin: EdgeInsets.all(10),
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
                  child: Image.asset('assets/images/icons/color.gif',
                    fit: BoxFit.cover, // 이미지가 원형을 채우도록 설정
                    width: 200,
                    height: 200,),
                )]
          ),
          SizedBox(height: 20,),
          Text(
            '이는 옷의 색상이 기억에 영향을 주기 때문입니다.',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 20,),
          Text(
            '그렇기에 색의 요소 중',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 5),
          Text(
              '색상, 명도, 채도',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600)
          ),
          SizedBox(height: 5),
          Text(
            '기준으로 기억도를 고려했습니다.',
            style: TextStyle(fontSize: 12),
          ),

        ],
      ),
    );
  }

  Widget _buildThirdCard() {
    return Container(
      margin: EdgeInsets.all(10),
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
                  child: Image.asset('assets/images/icons/chart.gif',
                    fit: BoxFit.contain, // 이미지가 원형을 채우도록 설정
                    width: 150,
                    height: 150,),
                )]
          ),
          SizedBox(height: 20),
          Text(
            '세 가지 항목의 값이 클 수록',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 5),
          Text(
            '더 오랫동안 기억에 남기에 ',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 5),
          Text(
            '더 큰 기억도를 가져요!',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 20),

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
