import 'package:flutter/material.dart';
import 'dart:ui';

class SettingsIcon extends StatelessWidget {
  final VoidCallback onTap;

  const SettingsIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 45.0, // 상태 표시줄 아래 여백
      right: 25.0, // 오른쪽에서의 여백
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0), // 테두리 둥글게
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // 블러 효과
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4), // 반투명 배경색
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.white.withOpacity(1.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8), // 아이콘 주변 여백
                child: Icon(
                  Icons.settings, // 설정 아이콘
                  color: Colors.grey, // 아이콘 색상
                  size: 30, // 아이콘 크기
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
