import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'dart:math';

import '../loaders.dart';
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
  late String? animationFile;

  Ability({
    required this.atlas,
    this.animationStep = 0.1,
    this.damage = 10,
  }) {
    size = Vector2.all(64);
    anchor = Anchor.center;

    bool usingJoystick = atlas.directionWASD == JoystickDirection.idle;

    // use joystick input
    if (usingJoystick) {
      angle = joystickAngle();
      if (atlas.joystick.delta.length == 0) {
        direction = Vector2(0, 1);
      } else {
        direction = atlas.joystick.delta / atlas.joystick.delta.length;
      }
    }
    // use WASD input
    else {
      direction = joystickDirToVector(atlas.directionWASD);
      angle = joystickAngle();
    }

    // print(direction);
  }

  // translate joystick direction to normal vector
  Vector2 joystickDirToVector(JoystickDirection direction) {
    Vector2 abilityVector;
    switch (direction) {
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
    bool usingJoystick = atlas.directionWASD == JoystickDirection.idle;
    Vector2 delta;

    // use joystick input
    if (usingJoystick) {
      delta = atlas.joystick.delta;
    }
    // use WASD input
    else {
      delta = joystickDirToVector(atlas.directionWASD);
    }

    double abilityAngle = 0;
    // check edge case angles
    if (delta.y == 0) {
      if (delta.x == 0) {
        abilityAngle = radians(0);
      } else if (delta.x > 0) {
        abilityAngle = radians(270);
      } else if (delta.x < 0) {
        abilityAngle = radians(90);
      }
    } else if (delta.x == 0) {
      if (delta.y > 0) {
        abilityAngle = radians(0);
      } else if (delta.y < 0) {
        abilityAngle = radians(180);
      }
    } else {
      double rads = atan(delta.x / delta.y);
      if (delta.x > 0) {
        if (delta.y > 0) {
          abilityAngle = -rads;
        } else {
          abilityAngle = radians(180) - rads;
        }
      } else {
        if (delta.y > 0) {
          abilityAngle = -rads;
        } else {
          abilityAngle = radians(180) - rads;
        }
      }
    }
    return abilityAngle;
  }

  Vector2 angleToVector() {
    double xx = sin(angle);
    double yy = cos(angle);
    return Vector2(-xx, yy);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = gameRef.atlas.position;

    if (animationFile != null) {
      animation = await createAnimation(
        gameRef,
        animationFile!,
        animationStep,
      );
    }
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

// move ability
abstract class MoveAbility extends Ability {
  Vector2 offset = Vector2(0, 0);

  late final Vector2 newPosition;
  late double moveSpeed;
  late int moveTimeMs;

  MoveAbility({
    required super.atlas,
    super.animationStep,
    double distance = 300, // px
    double speed = 750, // px / s
  }) {
    // movement variables
    newPosition = atlas.position + (angleToVector() * distance);
    moveSpeed = speed;

    // move speed constraints
    if (moveSpeed <= 0) {
      moveSpeed = 0;
      moveTimeMs = 500;
    } else if (moveSpeed >= 2000) {
      moveSpeed = 2000;
      moveTimeMs = (1000 * distance / speed).round();
    } else {
      moveTimeMs = (1000 * distance / speed).round();
    }

    // sticky animation sprite
    anchor = Anchor.center;
    angle = 0;
  }

  @override
  Future<void>? onLoad() {
    // teleport
    if (moveSpeed == 0) {
      atlas.position = newPosition;
      Future.delayed(Duration(milliseconds: moveTimeMs), () {
        gameRef.remove(this);
      });
    }

    // make character faster
    else {
      final double normalAtlasSpeed = atlas.characterSpeed;
      atlas.characterSpeed = moveSpeed;

      Future.delayed(Duration(milliseconds: moveTimeMs), () {
        atlas.characterSpeed = normalAtlasSpeed;
        gameRef.remove(this);
      });
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = atlas.position + offset;
  }
}
