import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'atlas.dart';
import '../main.dart';

class Obstacle extends PositionComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  bool _hasCollided = false;
  Obstacle() {
    debugMode = true;
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      if (!_hasCollided) {
        //0 =idle, 1=down, 2=left, 3=up, 4=right
        switch (gameRef.atlas.direction) {
          case Direction.idle:
            gameRef.atlas.collisionDirection = 0;
            break;
          case Direction.down:
            gameRef.atlas.collisionDirection = 1;
            break;
          case Direction.left:
            gameRef.atlas.collisionDirection = 2;
            break;
          case Direction.up:
            gameRef.atlas.collisionDirection = 3;
            break;
          case Direction.right:
            gameRef.atlas.collisionDirection = 4;
            break;
        }
        _hasCollided = true;

        print("collision :${gameRef.atlas.collisionDirection}");
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    super.onCollisionEnd(other);
    if (other is AtlasCharacter) {
      gameRef.atlas.collisionDirection = -1;
      _hasCollided = false;
    }
  }
}
