import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';
import '../characters/enemy.dart';

abstract class Ability extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  final double animationSpeed = .3;
  late Vector2 direction;

  Ability({required direction}) {
    this.direction = joystickDirToVector(direction);
    debugMode = true;
  }

  joystickDirToVector(JoystickDirection direction) {
    Vector2 abilityDir;
    switch (direction) {
      case JoystickDirection.up:
        abilityDir = Vector2(0, -1);
        break;
      case JoystickDirection.upLeft:
        abilityDir = Vector2(-1, -1);
        break;
      case JoystickDirection.upRight:
        abilityDir = Vector2(1, -1);
        break;
      case JoystickDirection.right:
        abilityDir = Vector2(1, 0);
        break;
      case JoystickDirection.down:
        abilityDir = Vector2(0, 1);
        break;
      case JoystickDirection.downRight:
        abilityDir = Vector2(1, 1);
        break;
      case JoystickDirection.downLeft:
        abilityDir = Vector2(-1, 1);
        break;
      case JoystickDirection.left:
        abilityDir = Vector2(-1, 0);
        break;
      case JoystickDirection.idle:
        abilityDir = Vector2(0, 1);
        break;
    }
    return abilityDir;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = gameRef.atlas.position;
    size = Vector2(50, 50);
  }
}

abstract class ThrownAbility extends Ability {
  final double moveSpeed = 100;

  ThrownAbility({required direction}) : super(direction: direction) {
    debugMode = true;
    add(CircleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = gameRef.atlas.position;
    size = Vector2(50, 50);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyCharacter) {
      other.health -= 1;
      gameRef.remove(other);
      gameRef.remove(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(direction * moveSpeed * dt);

    // switch x vel
    if (position.x - 25 > gameRef.mapWidth) {
      gameRef.remove(this);
    } else if (position.x < 0) {
      gameRef.remove(this);
    }

    // switch y vel
    if (position.y - 25 > gameRef.mapHeight) {
      gameRef.remove(this);
    } else if (position.y < 0) {
      gameRef.remove(this);
    }
  }
}

class Fireball extends ThrownAbility {
  Fireball({required direction}) : super(direction: direction);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = Sprite(await gameRef.images.load("apple_pie.png"));
  }
}

class Iceball extends ThrownAbility {
  Iceball({required direction}) : super(direction: direction);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = Sprite(await gameRef.images.load("apple_pie.png"));
  }
}
