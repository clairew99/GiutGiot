import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/effects.dart';

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

// 작은 구슬 개수 고민중
// 정진영(24.08.12)

import 'package:GIUTGIOT/storage.dart';

import '../src/intro/colorBall.dart';
import '../src/intro/memoryBall.dart';
import '../src/intro/conversationBall.dart';

class MyGame extends Forge2DGame with HasCollisionDetection {
  final playArea = PlayArea();
  final Vector2 screenSize;
  bool isDropping = false; // isDropping을 false로 초기화

  List<double>? accelerometerValues;
  List<double>? gyroscopeValues;

  // 이미 출력된 clothID와 메모리 값을 저장하는 Map
  // 데이터 변화 감지 후 옷 구슬 출력을 위함
  Map<int, MapEntry<GlassBall, double>> processedClothes = {};

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

      // 중력 벡터 업데이트
      Vector2 newGravity = Vector2(-accelerometer[0] * 30, accelerometer[1] * 30);

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



    // 작은 구슬 생성
    spawnSmallBalls();

    // intro 출력 구현
    // 기억도 관련 옷 데이터 개수가 5개보다 작으면 출력할 수 있도록 조건 설정
    // 정진영 (24.08.14)

    // intro 출력 조건
    // HomeClothPaths의 "forgotten"과 "remembered" 리스트의 길이 확인
    bool shouldShowIntro = HomeClothPaths['forgotten']!.length + HomeClothPaths['remembered']!.length < 5;
    if (shouldShowIntro) {
      await displayIntroBalls(); // intro 공을 비동기로 처리

    }

    // 구슬을 생성하는 비동기 작업을 시작
    await dropNewBalls();

  }

  // 설명 구슬 시간 차이 주기
  // 정진영 (24.08.15)
  Future<void> displayIntroBalls() async {
    await add(ColorBall(
      position: Vector2(screenSize.x / 2, 0),
      radius: 70,
    ));
    await ASYNC.Future.delayed(const Duration(milliseconds: 1000));

    await add(ConversationBall(
      position: Vector2(screenSize.x / 2, 0),
      radius: 70,
    ));
    await ASYNC.Future.delayed(const Duration(milliseconds: 1000));

    await add(MemoryBall(
      position: Vector2(screenSize.x / 2, 0),
      radius: 70,
    ));
  }


  Future<void> spawnSmallBalls() async {
    // 상단 넓은 부분에서 중간 좁은 부분으로 퍼져서 배치
    for (var i = 0; i < 30; i++) {
      double initialPosition_x =  Random().nextInt(screenSize.x.toInt()).toDouble();
      final smallball = SmallBall(
        marbleURL: 'marble.png',
        position: Vector2(initialPosition_x, 0),
      );

      await add(smallball);
      await ASYNC.Future.delayed(const Duration(milliseconds: 1000)); // 공 생성 후 0.6초 지연
    }
  }


  Future<void> dropNewBalls() async {
    double InitialRadius_L = 75;
    double InitailRadius_S = 60;
    double radiusIncrement = 10;
    print ('myGame.dart :  $HomeClothPaths');
    for (var key in HomeClothPaths.keys) {
      var paths = HomeClothPaths[key];
      if (paths == null) {
        continue;
      }

      for (var i = 0; i < paths.length; i++) {
        int clothID = paths[i][0];
        double memory = paths[i][1];
        String clothURL = paths[i][2];

        // 새로운 데이터인지 확인
        // 테스트 아직 완성되지 않음 (캘린더 등록 X)
        if (!processedClothes.containsKey(clothID)) {
          // 새로운 메모리 값으로 구슬 생성
          int initialPosition_X = (screenSize.x / 2).toInt() - 80 + Random().nextInt(160);

          if (memory >= 0.2) {
            InitialRadius_L += radiusIncrement * ((memory - 0.2) / 0.8);
          }

          final ball = key == 'remembered'
              ? GlassBall(
            marbleURL: 'marble.png',
            clothID: clothID.toDouble(),
            clothURL: clothURL,
            position: Vector2(initialPosition_X.toDouble(), 0),
            radius: InitialRadius_L,
          )
              : GlassBall(
            marbleURL: 'marble.png',
            clothID: clothID.toDouble(),
            clothURL: clothURL,
            position: Vector2(initialPosition_X.toDouble(), 0),
            radius: InitailRadius_S,
          );

          await add(ball);

          // 새로운 구슬과 메모리를 processedClothes에 추가
          processedClothes[clothID] = MapEntry(ball, memory);

          await ASYNC.Future.delayed(const Duration(milliseconds: 800));
        }
      }
      await ASYNC.Future.delayed(const Duration(milliseconds: 1300));
    }
  }

  void startDroppingNewBalls() {
    if (!isDropping) {
      isDropping = true;
      dropNewBalls().then((_) {
        isDropping = false;
      });
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