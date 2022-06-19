import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';
import '../characters/enemy.dart';

// general ability
abstract class Ability extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  late double animationStep;
  late Vector2 direction;

  Ability({required JoystickDirection direction, this.animationStep = 0.1}) {
    this.direction = joystickDirToVector(direction);
    size = Vector2.all(64);
    anchor = Anchor.center;
    debugMode = true;
  }

  Vector2 joystickDirToVector(JoystickDirection direction) {
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

  Future<SpriteAnimation> createAnimation(
    String animationFile,
  ) async {
    return await gameRef.loadSpriteAnimation(
      animationFile,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(32),
        stepTime: animationStep,
      ),
    );
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = gameRef.atlas.position;
  }
}

// cqb ability
abstract class MeleeAbility extends Ability {
  late Timer clock;
  int meleeCycles;

  MeleeAbility(
      {required super.direction, super.animationStep, this.meleeCycles = 1}) {
    debugMode = true;
    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyCharacter) {
      other.health -= 10;
      other.position.add(direction * 10);
    }
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    clock = Timer(
      animationStep * meleeCycles,
      repeat: false,
      autoStart: false,
      onTick: () {
        gameRef.remove(this);
      },
    );
    clock.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = gameRef.atlas.position;
    clock.update(dt);
  }
}

// ranged ability
abstract class ThrownAbility extends Ability {
  final double moveSpeed = 100;

  ThrownAbility({required super.direction, super.animationStep}) {
    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyCharacter) {
      other.health -= 2;
      other.position.add(other.randomMove * -0.005);
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
