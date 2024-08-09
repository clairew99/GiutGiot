import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart'; // Path is defined here


import 'components/play_area.dart';
import 'components/smallglassBall.dart';
import 'components/glassBall.dart';
import 'components/boundary.dart';

import 'package:GIUTGIOT/storage.dart';

class MyGame extends Forge2DGame with HasCollisionDetection {
  final playArea = PlayArea();
  final Vector2 screenSize;

  MyGame({required this.screenSize})
      : super(
    zoom: 100,
    gravity: Vector2(0, screenSize.y), // 속도 조절 X - 정진영 (24.08.07)
    camera: CameraComponent.withFixedResolution(
      width: screenSize.x ,
      height: screenSize.y  ,
    ),
  );

  // small ball
  final ball = SmallBall(
      marbleURL: 'marble.png',
      position: Vector2(100, 400),
      radius: 20);


  final ball1 = SmallBall(
      marbleURL: 'marble.png',
      position: Vector2(100, 400),
      radius: 80);

  final ball2 = SmallBall(
      marbleURL: 'marble.png',
      position: Vector2(100, 200),
      radius: 90);

  final ball3 = SmallBall(
      marbleURL: 'marble.png',
      position: Vector2(100, 200),
      radius: 60);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final path1 = Path()
      ..moveTo(0, screenSize.y * 0.34)
      ..cubicTo(screenSize.x * 0.13, screenSize.y * 0.48, screenSize.x * 0.68,
          screenSize.y * 0.575, 0, screenSize.y * 0.735)
      ..close();

    final path2 = Path()
      ..moveTo(screenSize.x, screenSize.y * 0.34)
      ..cubicTo(screenSize.x * 0.87, screenSize.y * 0.47, screenSize.x * 0.32,
          screenSize.y * 0.575, screenSize.x, screenSize.y * 0.735)
      ..close();


    final Vector2 centerPosition = size / 2;
    final double initialRadius = 40.0;

    final double maxRadius = 90;
    final double minRadius = 60;
    final radiusIncrement = 10 ;

    final double positionXIncrement = 30.0;
    final double positionYIncrement = 30.0;


    Vector2 startPosition = Vector2(centerPosition.x, centerPosition.y);
    // 가운데 출력으로 수정
    // 정진영 (24.08.09)


    await add(playArea); // 배경 화면 로드
    await add(Boundary(path1));
    await add(Boundary(path2));



    // await add(ball1);  // 작은 유리 구슬
    // await add(ball2);  // 작은 유리 구슬
    // await add(ball3);  // 작은 유리 구슬

    for (var key in HomeClothPaths.keys) {
      var paths = HomeClothPaths[key];

      if (paths != null) {
        for (var i = 0; i < paths.length /3 ; i++) {
          String clothURL = paths[i] as String;
          double field = paths[i + 1] as double;

          // field 값 20 % 이하 일 경우 : 모래시계 가운데 딱 막히는 사이즈 (80)
          // maxSize = 90
          // minSize = 60
          // 정진영 (24.08.09)

          double radius = 60;

          if (field >= 0.2) {
            // field가 0.2 이상일 때 radius는 80~90 사이
            radius = 80 + ((90 - 80) * ((field - 0.2) / 0.8));
          } else {
            // field가 0.2 미만일 때 radius는 60~79 사이
            radius += (10 * (field / 0.2));
          }

          // // 기억하고 있는 옷의 위치
          // final Vector2 position_forgotten = centerPosition +
          //     Vector2(positionXIncrement * i, positionYIncrement * i * 3);
          //
          // // 잊혀진 옷의 위치
          // final Vector2 position_remembered = centerPosition +
          //     Vector2(positionXIncrement * i * 3, positionYIncrement * i );



          i++; // field 값을 읽었으므로 인덱스를 증가시킴
          if (key == 'remembered') {
            // GlassBall을 생성하여 추가
            add(GlassBall(
              marbleURL: 'marble.png', // marble 이미지 경로
              clothURL: clothURL,
              position: startPosition, // position을 정의해 주어야 합니다
              radius: radius,     // radius를 정의해 주어야 합니다
            ));
          } else if (key == 'forgotten') {
            add(GlassBall(
              marbleURL: 'marble.png', // marble 이미지 경로
              clothURL: clothURL,
              position:  startPosition, // position을 정의해 주어야 합니다
              radius: radius,     // radius를 정의해 주어야 합니다
            ));
          }
          // 다음 공을 추가하기 전에 충분한 지연시간 추가 (예: 1초)
          // await Future.delayed(Duration(seconds: 1));
        }
      }
    }


      // await add(ball);  // 작은 유리 구슬



      await add(ScreenHitbox());
    }

    @override
    void update(double dt) {
      super.update(dt);
    }

    @override
    void onRemove() {
      super.onRemove();
    }
  }
