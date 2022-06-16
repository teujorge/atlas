import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:george/characters/george.dart';
import '../main.dart';

class ObstacleComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<GeorgeGame> {
  bool _hasCollided = false;
  ObstacleComponent() {
    debugMode = true;
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    if (other is GeorgeComponent) {
      if (!_hasCollided) {
        //0 =idle, 1=down, 2=left, 3=up, 4=right
        switch (gameRef.george.direction) {
          case Direction.idle:
            gameRef.george.collisionDirection = 0;
            break;
          case Direction.down:
            gameRef.george.collisionDirection = 1;
            break;
          case Direction.left:
            gameRef.george.collisionDirection = 2;
            break;
          case Direction.up:
            gameRef.george.collisionDirection = 3;
            break;
          case Direction.right:
            gameRef.george.collisionDirection = 4;
            break;
        }
        _hasCollided = true;

        print("collision :${gameRef.george.collisionDirection}");
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    super.onCollisionEnd(other);
    if (other is GeorgeComponent) {
      gameRef.george.collisionDirection = -1;
      _hasCollided = false;
    }
  }
}
