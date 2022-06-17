import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'atlas.dart';
import '../main.dart';

class EnemyCharacter extends PositionComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  RectangleHitbox hitbox = RectangleHitbox();
  EnemyCharacter() {
    // debugMode = true;
    add(hitbox);
  }
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is AtlasCharacter) {
      if (gameRef.bakedGoodsInventory > 0) {
        gameRef.friendNumber++;
        print("friends #: ${gameRef.friendNumber}");
        gameRef.bakedGoodsInventory--;
        print("baked goods inventory: ${gameRef.bakedGoodsInventory}");
      } else {}
      gameRef.remove(this); // remove bounding box
    }
  }
}
