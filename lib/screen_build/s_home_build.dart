// page_view_item.dart
import 'package:flutter/material.dart';
import '../screen/s_calendar.dart';

class PageViewItem extends StatelessWidget {
  final PageController pageController; // PageController는 PageView의 스크롤 상태를 제어
  final int index; // 현재 페이지 인덱스를 나타내는 변수

  const PageViewItem({
    Key? key,
    required this.pageController,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController, // PageController를 애니메이션의 기반으로 사용
      builder: (context, child) {
        double opacity = 1.0; // 초기 불투명도 값 설정
        if (pageController.position.haveDimensions) {
          double pageOffset = pageController.page! - index;
          // 페이지 오프셋에 따라 불투명도 계산: 페이지가 멀어질수록 투명해짐
          opacity = (1 - (pageOffset.abs() * 0.5)).clamp(0.0, 1.0);
        }
        return Opacity(
          opacity: opacity, // 계산된 불투명도로 설정
          child: child, // 자식 위젯 전달
        );
      },

      // 화면 구현 내용
      child: Stack(
        children: [
          // 첫 번째 배경 이미지 (GIF)
          Positioned.fill(
            child: Image.asset(
              'assets/background/bg.gif', // GIF 파일 경로
              fit: BoxFit.cover, // 이미지를 화면에 맞게 채움
            ),
          ),
          // 두 번째 배경 이미지 (PNG)
          Positioned.fill(
            child: Image.asset(
              'assets/background/hourglass.png', // PNG 파일 경로
              fit: BoxFit.cover, // 이미지를 화면에 맞게 채움
            ),
          ),
          // 메인 콘텐츠
          index == 0
              ? const Center(
            child: Text('Home Screen Content'), // 홈 화면 콘텐츠
          )
              : const CalendarScreen(), // 두 번째 페이지는 CalendarScreen
        ],
      ),
    );
  }
}
