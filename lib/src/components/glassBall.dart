import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:ui'; // Canvas를 사용하기 위해 dart:ui를 임포트

class GlassBall extends BodyComponent with HasGameRef<Forge2DGame> {
  final String marbleURL;
  final String clothURL;
  final Vector2 position;
  final double radius;
  final double collisionMargin; // 충돌 마진 추가

  GlassBall({
    required this.marbleURL,
    required this.clothURL,
    required this.position,
    required this.radius,
    this.collisionMargin = 15, // 기본 충돌 마진 설정
  });

  late Sprite marbleSprite;
  late Sprite clothSprite;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    marbleSprite = await gameRef.loadSprite(marbleURL);
    clothSprite = await gameRef.loadSprite(clothURL);
  }

  @override
  void render(Canvas canvas) {
    // marbleSprite를 렌더링합니다.
    marbleSprite.render(
      canvas,
      size: Vector2.all(radius * 2),
      position: Vector2(-radius, -radius), // 스프라이트의 위치를 중심
      // anchor: Anchor.center
    );

    // 옷 사이즈를 위한 factor - 정진영 (24.08.09)
    double clothSizeFactor = 1.3 ;
    // clothSprite를 렌더링합니다.
    clothSprite.render(
      canvas,
      size: Vector2.all(radius * clothSizeFactor),
      position: Vector2.all(-radius * clothSizeFactor / 2), // 스프라이트의 위치를 중심에 맞춥니다.
      // anchor: Anchor.center
    );
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
    )
      ..linearDamping = 0.0; // Reduce damping to speed up falling
        ;
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