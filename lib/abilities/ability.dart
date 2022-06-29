import 'package:Atlas/characters/atlas.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'dart:math';

import '../main.dart';
import '../characters/enemy.dart';

// general ability
abstract class Ability extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  int damage = 10;
  double animationStep;
  AtlasCharacter atlas;
  late Vector2 direction;

  Ability({required this.atlas, this.animationStep = 0.1}) {
    direction = joystickDirToVector();
    size = Vector2.all(64);
    anchor = Anchor.center;
    debugMode = true;
  }

  // translate joystick direction to normal vector
  Vector2 joystickDirToVector() {
    Vector2 abilityVector;
    switch (atlas.joystick.direction) {
      case JoystickDirection.up:
        abilityVector = Vector2(0.0, -1.0);
        angle = radians(180);
        break;
      case JoystickDirection.upLeft:
        abilityVector = Vector2(-0.707, -0.707);
        angle = radians(150);
        break;
      case JoystickDirection.upRight:
        abilityVector = Vector2(0.707, -0.707);
        angle = radians(230);
        break;
      case JoystickDirection.right:
        abilityVector = Vector2(1.0, 0.0);
        angle = radians(270);
        break;
      case JoystickDirection.down:
        abilityVector = Vector2(0.0, 1.0);
        break;
      case JoystickDirection.downRight:
        abilityVector = Vector2(0.707, 0.707);
        angle = radians(330);
        break;
      case JoystickDirection.downLeft:
        abilityVector = Vector2(-0.707, 0.707);
        angle = radians(30);
        break;
      case JoystickDirection.left:
        abilityVector = Vector2(-1, 0);
        angle = radians(90);
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
}

// cqb ability
abstract class MeleeAbility extends Ability {
  late Timer clock;
  int meleeCycles;

  MeleeAbility(
      {required super.atlas, super.animationStep, this.meleeCycles = 1});

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyCharacter) {
      // damage
      other.health -= damage;
      // push
      other.position.add(direction * 10);
    }
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // ability timer
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

    // ability moves with atlas
    position = gameRef.atlas.position;

    // update timer
    clock.update(dt);
  }
}

// ranged ability
abstract class ThrownAbility extends Ability {
  final double moveSpeed = 200;

  ThrownAbility({required super.atlas, super.animationStep});

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyCharacter) {
      // damage
      other.health -= damage;
      //stagger
      other.position.add(other.randomMove * -0.005);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // move ability
    position.add(direction * moveSpeed * dt);

    // remove out of bounds abilities
    if (position.x - 25 > gameRef.mapWidth) {
      gameRef.remove(this);
    } else if (position.x < 0) {
      gameRef.remove(this);
    }
    if (position.y - 25 > gameRef.mapHeight) {
      gameRef.remove(this);
    } else if (position.y < 0) {
      gameRef.remove(this);
    }
  }
}
