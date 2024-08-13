import 'package:flutter/material.dart';
import 'dart:ui';

class ConversationDetailContent extends StatefulWidget {
  @override
  _ConversationDetailContentState createState() => _ConversationDetailContentState();
}

class _ConversationDetailContentState extends State<ConversationDetailContent> {
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
                  child: Image.asset('assets/images/icons/conversation.png',
                    fit: BoxFit.cover, // 이미지가 원형을 채우도록 설정
                    width: 150,
                    height: 150,),
                )]
          ),
          SizedBox(height: 20,),
          Text(
            '다른 사람들과 대화를 할 때 \n무의식적으로 상대방의 옷을\n보았던 경험이 있으신가요?',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20,),
          Text(
            '기억도는 이동 중 대화를 할 때 \n상대방과의 대화 길이를 파악하여 \n이를 기억에 대한 정보로 적용합니다.',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 16,),

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
                ClipOval(
                  child: Image.asset(
                    'assets/images/icons/chatting.gif',
                    fit: BoxFit.cover, // 이미지가 원형을 채우도록 설정
                    width: 200,
                    height: 200,
                  ),
                ),]
          ),
          SizedBox(height: 20,),
          Text(
            '대화 내용은 녹음되지 않습니다!',
            style: TextStyle(fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20,),
          Text(
            '대화 내용이 아닌, 함께 대화한 화자 수와 대화 길이 만을 파악합니다.',
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
                  child: Image.asset('assets/images/icons/chatting2.png',
                    fit: BoxFit.contain, // 이미지가 원형을 채우도록 설정
                    width: 200,
                    height: 200,),
                )]
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
            children: [
              Text(
                '대화를 오래 나눌수록',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '함께 대화를 나눈 사람이 많을수록!',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),          SizedBox(height: 20),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
            children: [Text(
              '해당 옷은 더 큰 기억도를 가져요!',
              style: TextStyle(fontSize: 12),
            )],
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