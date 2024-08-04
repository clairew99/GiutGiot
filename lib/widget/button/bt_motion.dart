import 'package:flutter/material.dart';
import 'dart:math';

class MotionButton extends StatefulWidget {
  @override
  _MotionButtonState createState() => _MotionButtonState();
}

class _MotionButtonState extends State<MotionButton> with SingleTickerProviderStateMixin {
  double _buttonPosition = 0.0; // 0.0: center, -1.0: top, 1.0: bottom
  String _upperText = "상의";
  String _lowerText = "하의";
  late AnimationController _controller;
  late Animation<double> _animation;
  // 처음 화면 들어가서
  bool _isSelectingUpperOrLower = true; //사용자가 상의 or 하의를 선택하는 단계
  bool _isSelectingType = false;    // 종류 선택 (반팔, 긴팔 / 반바지, 긴바지 )
  bool _isSelectingColor = false;
  List<Color> _colors = [
    Color(0xFFFFFF00), Color(0xFFFFFFF0), Color(0xFF63C284), // 엘로우 아이보리 카키
    Color(0xFFB6F7FA), Color(0xFF87CEEB), Color(0xFF000080), // 스카이블러 블루 네이비
    Color(0xFF800080), Color(0xFFF3BFFF), Color(0xFFA52A2A), // 퍼플 라벤더 브라운
    Color(0xFF000000), Color(0xFFFFFFFF), Color(0xFF808080), // 블랙 화이트 그레이
    Color(0xFFF23D55), Color(0xFFFFC0CB), Color(0xFFFFA500), // 레드 핑크 오렌지
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200), // 애니메이션 속도 설정
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _buttonPosition = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateButtonPosition(DragUpdateDetails details) {
    setState(() {
      _buttonPosition += details.primaryDelta! / 100; // 위치 업데이트
      if (_buttonPosition > 1.0) _buttonPosition = 1.0;
      if (_buttonPosition < -1.0) _buttonPosition = -1.0;
    });
  }

  void _onButtonAction() {
    if (_isSelectingUpperOrLower) {
      if (_buttonPosition <= -0.9) {
        // 상의가 선택됨
        setState(() {
          _upperText = "반팔";
          _lowerText = "긴팔";
          _isSelectingUpperOrLower = false;
          _isSelectingType = true;
        });
      } else if (_buttonPosition >= 0.9) {
        // 하의가 선택됨
        setState(() {
          _upperText = "반바지";
          _lowerText = "긴바지";
          _isSelectingUpperOrLower = false;
          _isSelectingType = true;
        });
      }
    } else if (_isSelectingType) {
      // 상의/하의의 구체적인 종류가 선택 후, 색상 선택하는 단계
      setState(() {
        _isSelectingType = false;
        _isSelectingColor = true;
      });
    }

    // 버튼을 가운데로 되돌림
    _controller.reset();
    _animation = Tween<double>(begin: _buttonPosition, end: 0.0).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple[50], // 연보라색 배경
          ),
        ),
        if (_isSelectingColor)
          ..._buildColorButtons(),
        if (_isSelectingType || _isSelectingUpperOrLower) ...[
          Positioned(
            top: 20,
            child: Text(
              _upperText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Text(
              _lowerText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        GestureDetector(
          onTap: _onButtonAction,
          onVerticalDragUpdate: _updateButtonPosition,
          onVerticalDragEnd: (_) => _onButtonAction(),
          child: Transform.translate(
            offset: Offset(0, _buttonPosition * 100), // 모션 버튼 위치 변경
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue[200]!, Colors.purple[100]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 색상 선택 버튼
  List<Widget> _buildColorButtons() {
    final double radius = 120.0;
    final double angleStep = 2 * pi / _colors.length;

    return List.generate(_colors.length, (index) {
      final double angle = angleStep * index;
      final double x = radius * cos(angle);
      final double y = radius * sin(angle);

      return Positioned(
        // 색상 가운데 위치
        left: x + 160 - 15,
        top: y + 160 - 15,
        child: GestureDetector(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _colors[index],
            ),
          ),
        ),
      );
    });
  }
}
