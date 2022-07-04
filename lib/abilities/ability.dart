import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'dart:math';

import '../main.dart';
import '../characters/enemy.dart';
import '../characters/atlas.dart';

// general ability
abstract class Ability extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  double damage;
  double animationStep;
  AtlasCharacter atlas;
  late Vector2 direction;

  Ability({
    required this.atlas,
    this.animationStep = 0.1,
    this.damage = 10,
  }) {
    size = Vector2.all(64);
    anchor = Anchor.center;
    angle = joystickAngle();
    // direction = joystickDirToVector();

    if (atlas.joystick.delta.length == 0) {
      direction = Vector2(0, 1);
    } else {
      direction = atlas.joystick.delta / atlas.joystick.delta.length;
    }
  }

  // translate joystick direction to normal vector
  Vector2 joystickDirToVector() {
    Vector2 abilityVector;
    switch (atlas.joystick.direction) {
      case JoystickDirection.up:
        abilityVector = Vector2(0.0, -1.0);
        break;
      case JoystickDirection.upLeft:
        abilityVector = Vector2(-0.707, -0.707);
        break;
      case JoystickDirection.upRight:
        abilityVector = Vector2(0.707, -0.707);
        break;
      case JoystickDirection.right:
        abilityVector = Vector2(1.0, 0.0);
        break;
      case JoystickDirection.down:
        abilityVector = Vector2(0.0, 1.0);
        break;
      case JoystickDirection.downRight:
        abilityVector = Vector2(0.707, 0.707);
        break;
      case JoystickDirection.downLeft:
        abilityVector = Vector2(-0.707, 0.707);
        break;
      case JoystickDirection.left:
        abilityVector = Vector2(-1, 0);
        break;
      case JoystickDirection.idle:
        abilityVector = Vector2(0, 1);
        break;
    }
    return abilityVector;
  }

  double joystickAngle() {
    double abilityAngle = 0;
    // check edge case angles
    if (atlas.joystick.delta.y == 0) {
      if (atlas.joystick.delta.x == 0) {
        abilityAngle = radians(0);
      } else if (atlas.joystick.delta.x > 0) {
        abilityAngle = radians(270);
      } else if (atlas.joystick.delta.x < 0) {
        abilityAngle = radians(90);
      }
    } else if (atlas.joystick.delta.x == 0) {
      if (atlas.joystick.delta.y > 0) {
        abilityAngle = radians(0);
      } else if (atlas.joystick.delta.y < 0) {
        abilityAngle = radians(180);
      }
    } else {
      double rads = atan(atlas.joystick.delta.x / atlas.joystick.delta.y);
      if (atlas.joystick.delta.x > 0) {
        if (atlas.joystick.delta.y > 0) {
          abilityAngle = -rads;
        } else {
          abilityAngle = radians(180) - rads;
        }
      } else {
        if (atlas.joystick.delta.y > 0) {
          abilityAngle = -rads;
        } else {
          abilityAngle = radians(180) - rads;
        }
      }
    }
    return abilityAngle;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = gameRef.atlas.position;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyCharacter) {
      // damage
      other.health -= damage;
      // push
      other.position.add(-other.atlasDirection * 0.005);
    }
  }

  void removeAbility() {
    gameRef.atlas.usingAbility = false;
    gameRef.remove(this);
  }
}

// cqb ability
abstract class MeleeAbility extends Ability {
  late Timer clock;
  int meleeCycles;

  MeleeAbility({
    required super.atlas,
    super.animationStep,
    super.damage,
    this.meleeCycles = 1,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // cannot do another ability while doing melee
    gameRef.atlas.usingAbility = true;

    // ability timer
    clock = Timer(
      animationStep * meleeCycles,
      repeat: false,
      autoStart: false,
      onTick: () {
        removeAbility();
      },
    );
    clock.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // ability moves with atlas
    position = gameRef.atlas.position;

    // update timer
    clock.update(dt);
  }
}

// ranged ability
abstract class ThrownAbility extends Ability {
  final double moveSpeed = 200;

  ThrownAbility({
    required super.atlas,
    super.animationStep,
    super.damage,
  });

  @override
  void update(double dt) {
    super.update(dt);

    // move ability
    position.add(direction * moveSpeed * dt);

    // remove out of bounds abilities
    if (position.x - 25 > gameRef.mapWidth) {
      removeAbility();
    } else if (position.x < 0) {
      removeAbility();
    }
    if (position.y - 25 > gameRef.mapHeight) {
      removeAbility();
    } else if (position.y < 0) {
      removeAbility();
    }
  }
}
