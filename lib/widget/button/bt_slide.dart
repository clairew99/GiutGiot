import 'package:flutter/material.dart';

class SlideBar extends StatefulWidget {
  final PageController pageController;
  final int itemCount;

  const SlideBar({
    Key? key,
    required this.pageController,
    required this.itemCount,
  }) : super(key: key);

  @override
  _SlideBarState createState() => _SlideBarState();
}

class _SlideBarState extends State<SlideBar> {
  double _currentPosition = 0.0;
  double _dragStartY = 0.0;
  double _dragCurrentY = 0.0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        _currentPosition = widget.pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    widget.pageController.removeListener(() {});
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragCurrentY += details.delta.dy;
      double dragPercentage = _dragCurrentY / context.size!.height;
      double newPage = widget.pageController.page! + dragPercentage * widget.itemCount;
      widget.pageController.jumpToPage(newPage.round().clamp(0, widget.itemCount - 1));
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _dragCurrentY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sliderHeight = 100;
    double handleHeight = 50;
    double maxSlide = sliderHeight - handleHeight;
    double slidePosition = (_currentPosition / (widget.itemCount - 1)) * maxSlide;

    return GestureDetector(
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: Container(
        width: 5, // 이미지처럼 얇은 슬라이드 바 너비 설정
        height: sliderHeight,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2), // 반투명한 검정색 배경
          borderRadius: BorderRadius.circular(2.5), // 모서리 둥글게
        ),
        child: Stack(
          children: [
            Positioned(
              top: slidePosition,
              left: 0,
              right: 0,
              child: Container(
                height: handleHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
