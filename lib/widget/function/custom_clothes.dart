import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';



class CustomClothesWidget extends StatelessWidget {
  final String topColor;
  final String bottomColor;
  final String dateText;
  final String pose;

  const CustomClothesWidget({super.key, required this.topColor, required this.bottomColor, required this.dateText, required this.pose});



  // Sit
  final String sitTopSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 115.48 128.96">
    <path fill="none" stroke="#000000" stroke-miterlimit="10" stroke-width="13px" d="M37.03,64.87c1.03,1.13,11.49,12.21,25.11,10.22,8.59-1.25,28.15-22.65,24.89-39.89"/>
  </svg>''';

  final String sitBottomSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 115.48 128.96">
    <path fill="none" stroke="#000000" stroke-miterlimit="10" stroke-width="13px" d="M5.59,107.31c10.89-18.3,16.5-23.92,21.78-23.51,12.27,.96,16.05,21.54,29.11,23.36,14.03,1.96,26.65-10.13,27.71-11.55,2.56-3.44,3.62-45.97,2.66-52.64"/>
  </svg>''';

  final String sitHeadSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 539.34 700">
  <g id="a"/>
  <g id="b" transform="translate(-60, -20)">
    <circle fill="#000000" cx="500" cy="100" r="55.91"/>
  </g>
</svg>

''';


  // Run ( = STAND)
  final String standHeadSvg = '''<svg id="a" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120.59 140.96">
    <circle cx="55.95" cy="10.91" r="10.91" stroke="#231815" stroke-width="2"/>
</svg>''';

  final String standBottomSvg ='''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 106.59 128.96">
    <path fill="none" stroke="#000000" stroke-miterlimit="10" stroke-width="13px" d="M39.46,102.43c-1.19-1.1-14.81-14.12-11.75-32.13,2.64-15.52,16.68-28.89,24.22-26.62,7.46,2.25,12.34,20.97,5.52,84.65"/>
</svg>''';

  final String standTopSvg ='''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 106.59 128.96">
    <path fill="none" stroke="#000000" stroke-miterlimit="10" stroke-width="13px" d="M3.73,42.21c4.41-2.78,13.85-9.09,22.78-8.87,13.99,.33,19.85,9.57,33.09,10.55,8.87,.66,25.26,2.41,43.41-8.39"/>
</svg>''';



// Running
  final String RunningHeadSvg = '''<svg id="a" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 300">
    <circle fill="#000000" cx="150" cy="80" r="25" transform="translate(0, -40)"/> 
</svg>''';

  final String RunningTopSvg = '''<svg id="a" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 300">
    <path fill="none" stroke="#000000" stroke-miterlimit="10" stroke-width="25px" d="M50.17,120c8.18-4.59,20.4-12.95,35.33-12.33,20.16,1.35,24.48,12.06,42,16.45,12.54,3.39,46.12-.62,72.33-16.51" transform="translate(-40, -40) scale(1.5, 1.2)"/>
</svg>''';

  final String RunningBottomSvg = '''<svg id="a" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 300">
    <path fill="none" stroke="#000000" stroke-miterlimit="10" stroke-width="23px" d="M60.5,220c42.25-22,32.67-71.1,51.67-68.33,18.51,2.71,46.33,40.64,35.33,81.33" transform="translate(20, -170) scale(1.2, 2.0)"/>
</svg>''';


  @override
  Widget build(BuildContext context) {
    String topSvg,bottomSvg,headSvg;
    switch (pose.toUpperCase()) {
      case 'SITTING':
        topSvg = sitTopSvg;
        bottomSvg = sitBottomSvg;
        headSvg = sitHeadSvg;
        break;
      case 'RUNNING':
        topSvg = RunningTopSvg;
        bottomSvg = RunningBottomSvg;
        headSvg = RunningHeadSvg;
        break;
      case 'STANDING':
        topSvg = standTopSvg;
        bottomSvg = standBottomSvg;
        headSvg = standHeadSvg;
        break;
      default:
      // Default to standing pose if an unknown pose is provided
        topSvg = sitTopSvg;
        bottomSvg = sitBottomSvg;
        headSvg = sitHeadSvg;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [Text(
            dateText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          ],
        ),
        const SizedBox(height: 20), // 날짜와 이미지 사이의 간격
        Flexible(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                width: 38, // 원하는 너비 설정
                height: 38, // 원하는 높이 설정
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: SvgPicture.string(
                        bottomSvg.replaceAll('#000000', bottomColor),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned.fill(
                      child: SvgPicture.string(
                        headSvg.replaceAll('#000000', '#000000'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned.fill(
                      child: SvgPicture.string(
                        topSvg.replaceAll('#000000', topColor),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}