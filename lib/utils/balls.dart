import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Ball extends BodyComponent {
  final Vector2 _position;
  final double radius;
  final Paint paint;

  Ball(this._position, {this.radius = 2, Color? color})
      : paint = Paint()
    ..color = color ?? const Color(0xFFFFFFFF)
    ..style = PaintingStyle.fill;

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.8,
      friction: 0.4,
      density: 1.0,
    );

    final bodyDef = BodyDef(
      position: _position,
      type: BodyType.dynamic,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    // 기존의 물리엔진을 이용해 그리기 처리
    final body = this.body;
    final worldCenter = body.worldCenter;
    canvas.drawCircle(
      Offset(worldCenter.x, worldCenter.y),
      radius,
      paint,
    );
  }

  @override
  void update(double dt) {
    // 물리적 변화를 처리
  }
}
