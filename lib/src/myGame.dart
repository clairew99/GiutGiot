import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import 'components/play_area.dart';
import 'components/smallglassBall.dart';
import 'components/glassBall.dart';
import 'components/boundary.dart';

// 자이로센서 및 가속도 센서
// 중력 벡터 및 민감도 조정중
// 정진영 (24.08.11)

import 'dart:async' as ASYNC;
import '../models/sensor_management.dart';
import 'dart:math';

import 'package:GIUTGIOT/storage.dart';

class MyGame extends Forge2DGame with HasCollisionDetection {
  final playArea = PlayArea();
  final Vector2 screenSize;
  bool isDropping = false; // isDropping을 false로 초기화

  List<double>? accelerometerValues;
  List<double>? gyroscopeValues;

  MyGame({required this.screenSize})
      : super(
    zoom: 100,
    gravity: Vector2(0,screenSize.y),
    camera: CameraComponent.withFixedResolution(
      width: screenSize.x,
      height: screenSize.y,
    ),
  );

  void update(double dt) {
    super.update(dt);

    // sensorData의 마지막 값을 가져와 중력 벡터로 활용
    if (sensorData.isNotEmpty) {
      List<double> lastSensorValues = sensorData.last;

      // 가속도계 값, 자이로스코프 값, 사용자 가속도계 값을 추출
      List<double> accelerometer = lastSensorValues.sublist(0, 3);
      List<double> gyroscope = lastSensorValues.sublist(3, 6);

      // 중력 벡터 업데이트 (예시)
      Vector2 newGravity = Vector2(-accelerometer[0] * 15, accelerometer[1] * 15);

      // 자이로스코프 데이터를 통해 보정
      double gyroX = gyroscope[0];
      double gyroY = gyroscope[1];
      double sensitivity = 0.1;

      newGravity.x -= gyroX * sensitivity;
      newGravity.y += gyroY * sensitivity;

      this.world.gravity = newGravity;

    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 화면 경계 형성
    await add(ScreenHitbox());

    // 모래 시계 벽 그리기
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

    await add(playArea); // 배경 화면 로드
    await add(Boundary(path1));
    await add(Boundary(path2));


    for (var i = 0 ; i < 80 ; i++){
      int initialPosition_x = Random().nextInt(screenSize.x.toInt());
      int initialPosition_y = Random().nextInt((screenSize.y * 0.34).toInt());

      final smallball = SmallBall(
          marbleURL: 'small_marble.png',
          position: Vector2(initialPosition_x.toDouble() , initialPosition_y.toDouble()));
      add(smallball);
    };
    // 구슬을 생성하는 비동기 작업을 시작
    startDroppingBalls();
  }

  Future<void> dropBalls() async {
    double InitialRadius_L = 80;
    double InitailRadius_S = 60;
    double radiusIncrement = 10;

    for (var key in HomeClothPaths.keys) {
      if (!isDropping) break; // isDropping이 false이면 루프 중단

      var paths = HomeClothPaths[key];
      if (paths == null) {
        isDropping = false; // paths가 null인 경우 중단
        break;
      }

      for (var i = 0; i < paths.length ; i++) {
        if (!isDropping) break; // isDropping이 false이면 루프 중단
        int clothID = paths[i][0] ;
        double memory = paths[i][1] ;
        String clothURL = paths[i][2] ;

        int initialPosition_X = Random().nextInt(screenSize.x.toInt());

        // 메모리 field 값 기준으로 사이즈 조정
        if (memory >= 0.2) {
          InitialRadius_L += radiusIncrement * ((memory - 0.2) / 0.8);
        } else {
          // InitailRadius_S +=  ((0.2 - field) / 0.2);
        }

        // i++; // field 값을 읽은 후 인덱스 증가

        final ball = key == 'remembered'
            ? GlassBall(
          marbleURL: 'marble.png',
          clothID : clothID.toDouble(),
          clothURL: clothURL,
          position: Vector2( screenSize.x/2, 0),
          radius: InitialRadius_L,
        )
            : GlassBall(
          marbleURL: 'marble.png',
          clothID : clothID.toDouble(),
          clothURL: clothURL,
          position : Vector2( screenSize.x/2, 0),
          // position: i%2 == 0
          //     ? Vector2(-100, screenSize.y * 0.34)
          //     : Vector2(screenSize.x + 100, screenSize.y * 0.34),
          radius: InitailRadius_S,
        );

        await add(ball);

        await ASYNC.Future.delayed(const Duration(milliseconds: 600)); // 공 생성 후 0.6초 지연
      }
        await ASYNC.Future.delayed(const Duration(milliseconds: 1000)); // 공 생성 후 1초 지연
    }

    isDropping = false; // 모든 공이 생성된 후 중단
  }
  void startDroppingBalls() {
    if (!isDropping) {
      isDropping = true;
      dropBalls();
    }
  }

  void stopDroppingBalls() {
    isDropping = false; // 구슬 떨어뜨리기 작업 중단
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}