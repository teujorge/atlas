import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';

class BakedGoodComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<GeorgeGame> {
  BakedGoodComponent() {
    debugMode = true;
    add(RectangleHitbox());
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    gameRef.bakedGoodsInventory++;
    gameRef.yummy.start();
    gameRef.remove(this);
    print("baked goods inventory: ${gameRef.bakedGoodsInventory}");
  }
}
