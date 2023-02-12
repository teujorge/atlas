import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'atlas.dart';
import '../main.dart';

class Obstacle extends PositionComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  bool _hasCollided = false;
  bool _verticalCollision = false;
  bool _horizontalCollision = false;
  List<JoystickDirection> _atlasCollisionDirections = [];
  Obstacle() {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      // check for vertical collision
      if (intersectionPoints.first.y + 2 >= intersectionPoints.last.y &&
          intersectionPoints.first.y - 2 <= intersectionPoints.last.y) {
        _verticalCollision = true;
      } else {
        _verticalCollision = false;
      }
      // check for horizontal collision
      if (intersectionPoints.first.x + 2 >= intersectionPoints.last.x &&
          intersectionPoints.first.x - 2 <= intersectionPoints.last.x) {
        _horizontalCollision = true;
      } else {
        _horizontalCollision = false;
      }

      if (!_hasCollided) {
        _atlasCollisionDirections = [];
        switch (gameRef.atlas.joystick.direction) {
          case JoystickDirection.idle:
            // nothing
            break;
          case JoystickDirection.upLeft:
            if (_verticalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.up);
            }
            if (_horizontalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.left);
            }

            break;
          case JoystickDirection.upRight:
            if (_verticalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.up);
            }
            if (_horizontalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.right);
            }
            break;

          case JoystickDirection.downRight:
            if (_verticalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.down);
            }
            if (_horizontalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.right);
            }
            break;
          case JoystickDirection.downLeft:
            if (_verticalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.down);
            }
            if (_horizontalCollision) {
              _atlasCollisionDirections.add(JoystickDirection.left);
            }
            break;
          default:
            _atlasCollisionDirections.add(gameRef.atlas.joystick.direction);
            break;
        }
        _hasCollided = true;
        gameRef.atlas.collisionDirections += _atlasCollisionDirections;
        // print("collision :${gameRef.atlas.collisionDirections}");
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is AtlasCharacter) {
      for (JoystickDirection dir in _atlasCollisionDirections) {
        gameRef.atlas.collisionDirections.remove(dir);
      }
      _atlasCollisionDirections = [];
      _hasCollided = false;
    }
  }
}
