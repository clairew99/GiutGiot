import 'package:flutter/material.dart';

class VoiceIcon extends StatelessWidget {
  const VoiceIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 45.0, // 상태 표시줄 아래 여백
      left: 25.0, // 왼쪽에서의 여백
      child: Padding(
        padding: EdgeInsets.all(8), // 아이콘 주변 여백
        child: Icon(
          Icons.fiber_smart_record, // 음성 아이콘
          color: Colors.black38, // 아이콘 색상
          size: 30, // 아이콘 크기
        ),
      ),
    );
  }
}
