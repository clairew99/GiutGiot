import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import './myGame.dart';  // MyGame 클래스의 경로에 맞게 임포트


// 페이지 이동 시 홈 화면 상태 변화 없도록 코드 작성 - 정진영 (24.08.10)


class HomeHourglassPage extends StatefulWidget {
  @override
  _HomeHourglassPageState createState() => _HomeHourglassPageState();
}

class _HomeHourglassPageState extends State<HomeHourglassPage> with AutomaticKeepAliveClientMixin {
  MyGame? _gameInstance;  // 게임 인스턴스를 nullable로 선언

  @override
  void initState() {
    super.initState();
    print('PageSlide() start ') ;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_gameInstance == null) {
      final screenSize = MediaQuery.of(context).size;
      final gameSize = Vector2(screenSize.width, screenSize.height);
      _gameInstance = MyGame(screenSize: gameSize);  // 게임 인스턴스 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);  // AutomaticKeepAliveClientMixin 사용 시 호출 필요

    return Scaffold(
      body: Center(

        child: _gameInstance != null
            ? GameWidget(game: _gameInstance!)  // 게임 인스턴스가 초기화되었을 때만 렌더링
            : CircularProgressIndicator(),  // 게임 인스턴스가 초기화되지 않았을 경우 로딩 인디케이터
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
