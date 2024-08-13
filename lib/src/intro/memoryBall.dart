import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'dart:ui'; // Canvas를 사용하기 위해 dart:ui를 임포트
import 'package:flutter/material.dart'; // 모달 팝업을 사용하기 위해 임포트
import 'introContent.dart';

class MemoryBall extends BodyComponent with HasGameRef<Forge2DGame>, TapCallbacks {
  final Vector2 position;
  final double radius;
  final double collisionMargin; // 충돌 마진 추가
  late Sprite marbleSprite;
  late Sprite iconSprite;



  MemoryBall({
    required this.position,
    required this.radius,
    this.collisionMargin = 15, // 기본 충돌 마진 설정

  });

  // 디버깅 : 저장되는 값의 이미지가 없을 경우
  // 정진영 (24.08.12)
  @override
  Future<void> onLoad() async {
    super.onLoad();
    final iconURL = 'icons/memory.png' ;
    marbleSprite = await gameRef.loadSprite('marble.png');
    try {
      iconSprite = await gameRef.loadSprite(iconURL);
    } catch (e) {
      // 이미지 로드 실패 시 기본 이미지 로드
      iconSprite = await gameRef.loadSprite(iconURL);
      // print('Cloth image not found at path: $clothURL, loaded default image instead. Error: $e');
    }
  }

  @override
  void render(Canvas canvas) {
    // marbleSprite를 렌더링합니다.
    marbleSprite.render(
      canvas,
      size: Vector2.all(radius * 2),
      position: Vector2(-radius, -radius), // 스프라이트의 위치를 중심으로 설정
    );

    // 옷 사이즈를 위한 factor
    double SizeFactor = 1.1;
    iconSprite.render(
      canvas,
      size: Vector2.all(radius * SizeFactor),
      position: Vector2.all(-radius * SizeFactor / 2), // 스프라이트의 위치를 중심에 맞춤
    );
  }

  // 상세 모달 팝업
  @override
  void onTapUp(TapUpEvent event) {
    final context = gameRef.buildContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Introcontent(
              contentType : 'memory'
          ); // CustomDialog 대신 ClothDetail 사용
        },
      );

    } else {
      print('BuildContext가 null입니다.');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 바디의 현재 위치를 가져옵니다.
    final pos = body.position;
    final gameSize = gameRef.size;

    // 스크린 밖으로 나가지 않도록 경계 검사 및 반응
    if (pos.x - radius <= 0 || pos.x + radius >= gameSize.x) {
      body.linearVelocity = Vector2(-body.linearVelocity.x, body.linearVelocity.y);
      body.setTransform(Vector2(pos.x.clamp(radius, gameSize.x - radius), pos.y), body.angle);
    }

    if (pos.y - radius <= 0 || pos.y + radius >= gameSize.y) {
      body.linearVelocity = Vector2(body.linearVelocity.x, -body.linearVelocity.y);
      body.setTransform(Vector2(pos.x, pos.y.clamp(radius, gameSize.y - radius)), body.angle);
    }

    // 각속도를 멈추는 로직
    if (body.linearVelocity.length < 0.1 && body.angularVelocity.abs() < 0.1) {
      body.linearVelocity = Vector2.zero();
      body.angularVelocity = 0;
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: position,
      type: BodyType.dynamic,
    );
    final shape = CircleShape()..radius = radius - collisionMargin; // 충돌 마진 적용
    final fixtureDef = FixtureDef(shape)
      ..density = 2.0 // 밀도 (값이 높을 수록 무겁다)
      ..friction = 1.0 // 마찰력
      ..restitution = 0.8; // 반발력

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..angularVelocity = radians(0); // 회전 각속도
  }
}
