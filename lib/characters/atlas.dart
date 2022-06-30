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
  double health = 100;
  double energy = 100;

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

  // ability cooldown timers
  double abilityCooldown1 = 1;
  double abilityCooldown2 = 1;
  double abilityCooldown3 = 1;
  bool usingAbility = false;

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
  bool ability1() {
    return false;
  }

  bool ability2() {
    return false;
  }

  bool ability3() {
    return false;
  }
}

class Mage extends AtlasCharacter {
  Mage({
    required super.position,
    required super.joystick,
  }) {
    abilityCooldown1 = 1.5;
    abilityCooldown2 = 5;
    abilityCooldown3 = 5;
  }

  @override
  bool ability1() {
    double energyReq = 15;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(Fireball(atlas: this, damage: 20));
      return true;
    }
    return false;
  }

  @override
  bool ability2() {
    double energyReq = 15;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(Iceball(atlas: this, damage: 20));
      return true;
    }
    return false;
  }

  @override
  bool ability3() {
    double energyReq = 50;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(Beam(atlas: this, damage: 5));
      return true;
    }
    return false;
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

  @override
  void update(double dt) {
    super.update(dt);

    // regain mana
    if (energy < 100) {
      energy += 0.2;
    }
  }
}

class Archer extends AtlasCharacter {
  Archer({
    required super.position,
    required super.joystick,
  }) {
    abilityCooldown1 = 2;
    abilityCooldown2 = 2;
    abilityCooldown3 = 2;
  }

  @override
  ability1() {
    double energyReq = 50;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(Arrow(atlas: this, damage: 1));
      return true;
    }
    return false;
  }

  @override
  ability2() {
    double energyReq = 50;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(Cluster(atlas: this, damage: 1));
      return true;
    }
    return false;
  }

  @override
  ability3() {
    double energyReq = 50;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(GreenHit(atlas: this, damage: 1));
      return true;
    }
    return false;
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

  @override
  void update(double dt) {
    super.update(dt);

    // regain stamina
    if (energy < 100) {
      energy += 0.5;
    }
  }
}

class Knight extends AtlasCharacter {
  Knight({
    required super.position,
    required super.joystick,
  }) {
    abilityCooldown1 = 1.5;
    abilityCooldown2 = 5;
    abilityCooldown3 = 5;
  }

  @override
  ability1() {
    if (!usingAbility) {
      energy += 10;
      gameRef.add(Sword(atlas: this, damage: 1));
      return true;
    }
    return false;
  }

  @override
  ability2() {
    double energyReq = 30;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(Whirlwind(atlas: this, damage: 1));
      return true;
    }
    return false;
  }

  @override
  ability3() {
    double energyReq = 50;
    if (energy > energyReq && !usingAbility) {
      energy -= energyReq;
      gameRef.add(Impact(atlas: this, damage: 1));
      return true;
    }
    return false;
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

  @override
  void update(double dt) {
    super.update(dt);

    // loose fury
    if (energy < 100) {
      energy -= 0.05;
    }
  }
}
