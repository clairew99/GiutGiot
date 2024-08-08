import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomClothesWidget extends StatelessWidget {
  final String topColor;
  final String bottomColor;
  final String dateText;

  CustomClothesWidget({required this.topColor, required this.bottomColor, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dateText,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20), // 날짜와 이미지 사이의 간격
        Flexible(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgfile/head.svg',
                width: 40,
                height: 40,
              ),
              SvgPicture.asset(
                'assets/svgfile/run_top.svg',
                width: 40,
                height: 40,
                color: Color(int.parse(topColor.replaceFirst('#', '0xff'))),
              ),
              SvgPicture.asset(
                'assets/svgfile/run_bottom.svg',
                width: 40,
                height: 40,
                color: Color(int.parse(bottomColor.replaceFirst('#', '0xff'))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
