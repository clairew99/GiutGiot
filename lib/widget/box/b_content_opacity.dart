import 'package:flutter/material.dart';

// 설정 화면 기본 세팅 (24.08 .04) - 정진영

class OpaqueBox extends StatelessWidget {
  final Widget child;
  final double opacity; // 박스의 불투명도
  final Color color; // 박스의 색상
  final EdgeInsets padding;   // 박스 내부의 여백
  final EdgeInsets margin;   // 박스 외부의 여백
  final double maxWidthFactor;   // 박스가 차지할 최대 너비 비율
  final double maxHeightFactor;   // 박스가 차지할 최대 높이 비율

  // 생성자 함수
  const OpaqueBox({
    Key? key,
    required this.child,
    this.opacity = 0.8,
    this.color = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
    this.margin = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    this.maxWidthFactor = 0.9,
    this.maxHeightFactor = 0.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // 박스를 중앙에 배치
      child: FractionallySizedBox(
        // 박스의 최대 크기를 부모 크기의 비율로 설정
        widthFactor: maxWidthFactor,
        heightFactor: maxHeightFactor,
        child: Container(
          padding: padding,
          margin: margin,
          constraints: BoxConstraints(
            // 박스의 최대 크기를 화면 비율로 설정
            maxWidth: MediaQuery.of(context).size.width * maxWidthFactor,
            maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: BorderRadius.circular(20.0), // 모서리를 둥글게 설정
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // 그림자 색상과 불투명도
                spreadRadius: 2, // 그림자 확산 반경
                blurRadius: 8, // 그림자 흐림 정도
                offset: Offset(0, 4), // 그림자의 오프셋 (x, y)
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
