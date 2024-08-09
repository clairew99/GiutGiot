// // cloth_marbles_grid.dart
// import 'package:flutter/material.dart';
// import '../widget/function/w_cloth_loader.dart';
// import '../widget/function/w_cloth_marble.dart';
// import '../widget/function/w_cloth_item.dart';
//
// // Custom Clipper import
//
// class ClothMarblesGrid extends StatelessWidget {
//   final String jsonFilePath;
//
//   const ClothMarblesGrid({Key? key, required this.jsonFilePath}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ClothLoader(
//       jsonFilePath: jsonFilePath,
//       builder: (context, List<ClothItem> clothItems) {
//         final topItems = clothItems.where((item) => item.field > 0).toList();
//         final bottomItems = clothItems.where((item) => item.field <= 0).toList();
//
//         return LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//             double width = constraints.maxWidth;
//             double height = constraints.maxHeight;
//
//             return Column(
//               children: [
//                 // ClipPath widget to use the MyClipper
//                 // CustomPaint(
//                 //   size: Size(width, height), // 화면 크기에 따라 크기 설정
//                 //   painter: CurvePainter(),   // 곡선 그리기
//                 // ),
//                 Expanded(
//                   child: CustomScrollView(
//                     physics: NeverScrollableScrollPhysics(), // Disable scrolling
//                     slivers: [
//                       SliverGrid(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 10.0,
//                           mainAxisSpacing: 10.0,
//                         ),
//                         delegate: SliverChildBuilderDelegate(
//                               (context, index) {
//                             final item = topItems[index];
//                             return ClothMarble(
//                               marbleImagePath: 'assets/icon/marble.png',
//                               clothItem: item,
//                             );
//                           },
//                           childCount: topItems.length,
//                         ),
//                       ),
//                       SliverToBoxAdapter(
//                         child: Container(
//                           height: 100.0,
//                           child: Center(child: Text('Bottom Items')),
//                         ),
//                       ),
//                       SliverGrid(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 10.0,
//                           mainAxisSpacing: 10.0,
//                         ),
//                         delegate: SliverChildBuilderDelegate(
//                               (context, index) {
//                             final item = bottomItems[index];
//                             return ClothMarble(
//                               marbleImagePath: 'assets/icon/marble.png',
//                               clothItem: item,
//                             );
//                           },
//                           childCount: bottomItems.length,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
