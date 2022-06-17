import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';

class BakedGoodComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  BakedGoodComponent() {
    debugMode = true;
    add(RectangleHitbox());
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    gameRef.remove(this);
  }
}
