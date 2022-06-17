import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';

class EnemyCharacter extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  final double animationSpeed = .3;

  EnemyCharacter() {
    // debugMode = true;
    add(RectangleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = Vector2(200, 200);
    animation = SpriteSheet(
      image: await gameRef.images.load("enemies/enemy.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 4,
    );
  }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   super.onCollisionEnd(other);
  //   if (other is AtlasCharacter) {
  //     gameRef.remove(this);
  //   }
  // }

  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   position.add(Vector2(2, 1) * dt);
  // }
}
