import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';
import '../loaders.dart';
import '../abilities/abilities.dart';

abstract class AtlasCharacter extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  // score
  final kills = ValueNotifier<int>(0);
  final health = ValueNotifier<int>(100);

  // char movement
  final double animationSpeed = .3;
  final double characterSize = 60;
  final double characterSpeed = 80;
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;
  final JoystickComponent joystick;
  List<JoystickDirection> collisionDirections = [];

  AtlasCharacter({required position, required this.joystick})
      : super(position: position) {
    debugMode = true;
    anchor = Anchor.center;
    size = Vector2.all(characterSize);
    add(
      RectangleHitbox(
        size: Vector2(40, 25),
        position: Vector2((characterSize / 2) - 20, (characterSize / 2) + 5),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // update caharacter location based on walk
    switch (joystick.direction) {
      case JoystickDirection.idle:
        animation = idleAnimation;
        break;

      case JoystickDirection.up:
        animation = upAnimation;
        if (y > size.y / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        break;

      case JoystickDirection.upLeft:
        animation = leftAnimation;
        if (y > height / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }

        break;

      case JoystickDirection.upRight:
        animation = rightAnimation;

        if (y > height / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }

        break;

      case JoystickDirection.down:
        animation = downAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        break;

      case JoystickDirection.downLeft:
        animation = leftAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;

      case JoystickDirection.downRight:
        animation = rightAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;

      case JoystickDirection.left:
        animation = leftAnimation;
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;

      case JoystickDirection.right:
        animation = rightAnimation;
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;
    }
  }

  // overwritten by children
  ability1() {}
  ability2() {}
  ability3() {}
}

class Mage extends AtlasCharacter {
  Mage({
    required super.position,
    required super.joystick,
  });

  @override
  ability1() {
    gameRef.add(Fireball(direction: joystick.direction));
  }

  @override
  ability2() {
    gameRef.add(Iceball(direction: joystick.direction));
  }

  @override
  ability3() {
    gameRef.add(Beam(direction: joystick.direction));
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    idleAnimation = await createAnimation(
      gameRef,
      "atlas/mage_idle.png",
      0.8,
    );
    upAnimation = await createAnimation(
      gameRef,
      "atlas/mage_up.png",
      animationSpeed,
    );
    downAnimation = await createAnimation(
      gameRef,
      "atlas/mage_down.png",
      animationSpeed,
    );
    leftAnimation = await createAnimation(
      gameRef,
      "atlas/mage_left.png",
      animationSpeed,
    );
    rightAnimation = await createAnimation(
      gameRef,
      "atlas/mage_right.png",
      animationSpeed,
    );
  }
}

class Archer extends AtlasCharacter {
  Archer({
    required super.position,
    required super.joystick,
  });

  @override
  ability1() {
    gameRef.add(Arrow(direction: joystick.direction));
  }

  @override
  ability2() {
    gameRef.add(Cluster(direction: joystick.direction));
  }

  @override
  ability3() {
    gameRef.add(GreenHit(direction: joystick.direction));
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    idleAnimation = await createAnimation(
      gameRef,
      "atlas/archer_idle.png",
      0.8,
    );
    upAnimation = await createAnimation(
      gameRef,
      "atlas/archer_up.png",
      animationSpeed,
    );
    downAnimation = await createAnimation(
      gameRef,
      "atlas/archer_down.png",
      animationSpeed,
    );
    leftAnimation = await createAnimation(
      gameRef,
      "atlas/archer_left.png",
      animationSpeed,
    );
    rightAnimation = await createAnimation(
      gameRef,
      "atlas/archer_right.png",
      animationSpeed,
    );
  }
}

class Knight extends AtlasCharacter {
  Knight({
    required super.position,
    required super.joystick,
  });

  @override
  ability1() {
    gameRef.add(Sword(direction: joystick.direction));
  }

  @override
  ability2() {
    gameRef.add(Whirlwind(direction: joystick.direction));
  }

  @override
  ability3() {
    gameRef.add(Impact(direction: joystick.direction));
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    idleAnimation = await createAnimation(
      gameRef,
      "atlas/knight_idle.png",
      0.8,
    );
    upAnimation = await createAnimation(
      gameRef,
      "atlas/knight_up.png",
      animationSpeed,
    );
    downAnimation = await createAnimation(
      gameRef,
      "atlas/knight_down.png",
      animationSpeed,
    );
    leftAnimation = await createAnimation(
      gameRef,
      "atlas/knight_left.png",
      animationSpeed,
    );
    rightAnimation = await createAnimation(
      gameRef,
      "atlas/knight_right.png",
      animationSpeed,
    );
  }
}
