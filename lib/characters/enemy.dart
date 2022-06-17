import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'atlas.dart';
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
    size = Vector2(50, 50);

    animation = await gameRef.loadSpriteAnimation(
      "enemies/enemy.png",
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(32),
        stepTime: 0.15,
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      other.kills.value += 1;
      other.health.value -= 1;
      gameRef.remove(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(Vector2(2, 1) * 10 * dt);
  }
}
