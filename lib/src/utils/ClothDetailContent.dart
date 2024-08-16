import 'package:flutter/material.dart';
import 'dart:ui';

class ClothDetailContent extends StatefulWidget {
  final Map<String, dynamic> data;
  final String clothUrl;

  ClothDetailContent({required this.data, required this.clothUrl});

  @override
  _ClothDetailContentState createState() => _ClothDetailContentState();
}

class _ClothDetailContentState extends State<ClothDetailContent> {
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
      width: 500,
      height: 300, // PageView 높이 설정
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
      margin: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: 400, // 통일된 높이 설정
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
          Column(
            children: [Row(
                mainAxisAlignment: MainAxisAlignment.center, // 수평 가운데 정렬
                children: [
                  Text('${widget.data['color']}'),
                  SizedBox(width: 10), // 텍스트 사이의 간격 추가
                  Text('${widget.data['pattern']}'),
                ]
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.data['type']}'),
                  SizedBox(width: 10), // 텍스트 사이의 간격 추가
                  Text('${widget.data['category']}')
                ],
              ),
            ]
          ),
          SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              // 하얀색 원형 배경
              Container(
                width: 150, // 원형 배경의 지름
                height: 150, // 원형 배경의 지름
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
              // 옷 이미지
              Container(
                child: Image.asset(
                  'assets/images/${widget.clothUrl}',
                  width: 100, // 이미지의 너비
                  height: 100, // 이미지의 높이
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              Text(
                widget.data['leftTime'] == 0
                    ? '이 옷의 기억도는'
                    : '이 옷은 잊혀지기까지',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8), // 아이콘과 텍스트 사이의 간격
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                  children: [
                    SizedBox(width: 10)
                    ,Text(
                      '${widget.data['leftTime']}시간',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                  SizedBox(width: 5), // 아이콘과 텍스트 사이의 간격
                  Text(
                    widget.data['leftTime'] != 0
                        ? '남았습니다!'
                        : '입니다!',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),]
              ),

              SizedBox(height: 8), // 아이콘과 텍스트 사이의 간격
              Text(
                widget.data['leftTime'] == 0
                    ? '오늘 입어보시는 건 어떠세요?'
                    : '',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getConversationLevel(int count, int time) {
    // 간단한 레벨 기준 설정 (임의의 기준)
    if (count < 5 && time < 30) {
      return "Low";
    } else if (count < 10 && time < 60) {
      return "Medium";
    } else {
      return "High";
    }
  }

  List<Widget> _buildConversationImages(String level) {
    List<Widget> images = [];

    switch (level) {
      case "Low":
        images.add(Image.asset('assets/icon/conversation1.png', width: 100, height: 100));
        break;
      case "Medium":
        images.add(Image.asset('assets/icon/conversation1.png', width: 70, height: 70));
        images.add(SizedBox(width: 10)); // 이미지 사이의 여백 추가
        images.add(Image.asset('assets/icon/conversation2.png', width: 70, height: 70));
        break;
      case "High":
        images.add(Image.asset('assets/icon/conversation3_1.png', width: 50, height: 50));
        images.add(SizedBox(width: 10)); // 이미지 사이의 여백 추가
        images.add(Image.asset('assets/icon/conversation3_2.png', width: 50, height: 50));
        images.add(SizedBox(width: 10)); // 이미지 사이의 여백 추가
        images.add(Image.asset('assets/icon/conversation3_3.png', width: 50, height: 50));
        break;
      default:
        break;
    }
    return images;
  }



  String getConversationMessage(String level) {
    switch (level) {
      case "Low":
        return "여유로운 하루를 보내셨습니다.";
      case "Medium":
        return "이 옷을 입고 즐거운 대화를 나누셨군요!";
      case "High":
        return "활발한 대화를 나눈 멋진 하루였습니다.";
      default:
        return "대화 데이터를 확인할 수 없습니다.";
    }
  }


  Widget _buildSecondCard() {
    final int conversationCount = widget.data['conversationCount'] ?? 0;
    final int conversationTime = widget.data['conversationTime'] ?? 0;
    final String conversationLevel = getConversationLevel(
        conversationCount, conversationTime);
    final String conversationMessage = getConversationMessage(conversationLevel);

    final String lastWorn = widget.data['lastWorn'] ?? 'Unknown';



    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$lastWorn',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Conversation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildConversationImages(conversationLevel), // 이미지를 세로로 쌓아 표시
          ),
          SizedBox(height: 16),
          Text(
            '$conversationMessage',
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  String getWalkingLevel(int time) {
    // 간단한 레벨 기준 설정 (임의의 기준)
    if (time < 30) {
      return "Low";
    } else if (time < 60) {
      return "Medium";
    } else {
      return "High";
    }
  }


  Widget _buildThirdCard() {
    final int walkingTime = (widget.data['walkingTime'] ?? 0) ~/ 60000;
    final String walkingLevel = getWalkingLevel(walkingTime);
    final String lastWorn = widget.data['lastWorn'] ?? 'Unknown';


    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$lastWorn',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Walking Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildWalkingImages(walkingLevel), // 이미지를 나란히 출력
          ),
          SizedBox(height: 16),
          Text(
            '활동 시간은 $walkingTime 분 입니다!',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWalkingImages(String level) {
    List<Widget> images = [];

    switch (level) {
      case "Low":
        images.add(
            Image.asset('assets/icon/standing.gif', width: 150, height: 150));

        break;
      case "Medium":
        images.add(
            Image.asset('assets/icon/walking.gif',width: 150, height: 150));
        break;
      case "High":
        images.add(
            Image.asset('assets/icon/running.gif', width: 150, height: 150));
        break;
      default:
        images.add(
            Image.asset('assets/images/standing.png', width: 50, height: 50));
        break;
    }
    return images;
  }
}