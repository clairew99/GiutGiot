import 'package:flutter/material.dart';

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

  void _onDragEnd(DragEndDetails details) {
    if (_buttonPosition <= -0.9) {
      // 상의가 선택됨
      setState(() {
        _upperText = "반팔";
        _lowerText = "긴팔";
      });
    } else if (_buttonPosition >= 0.9) {
      // 하의가 선택됨
      setState(() {
        _upperText = "반바지";
        _lowerText = "긴바지";
      });
    }

    // 버튼을 가운데로 되돌림
    _controller.reset();
    _animation = Tween<double>(begin: _buttonPosition, end: 0.0).animate(_controller);
    _controller.forward();
  }

  void _onButtonTap() {
    if (_buttonPosition == -1.0) {
      setState(() {
        _upperText = "반팔";
        _lowerText = "긴팔";
      });
    } else if (_buttonPosition == 1.0) {
      setState(() {
        _upperText = "반바지";
        _lowerText = "긴바지";
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
        GestureDetector(
          onTap: _onButtonTap,
          onVerticalDragUpdate: _updateButtonPosition,
          onVerticalDragEnd: _onDragEnd,
          child: Transform.translate(
            offset: Offset(0, _buttonPosition * 100), // 위치 변경
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
}
