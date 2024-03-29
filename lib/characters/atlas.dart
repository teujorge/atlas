import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import '../loaders.dart';
import '../abilities/abilities.dart';

abstract class AtlasCharacter extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  // score
  final kills = ValueNotifier<int>(0);
  double health = 100;
  double energy = 100;
  double energyGain = 0.1;

  // char movement
  double characterSpeed = 80;
  final double animationSpeed = .3;
  final double characterSize = 80;
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;
  final JoystickComponent joystick;
  List<JoystickDirection> collisionDirections = [];
  JoystickDirection directionWASD = JoystickDirection.idle;

  // ability cooldown timers
  double abilityCooldown1 = 1;
  double abilityCooldown2 = 1;
  double abilityCooldown3 = 1;
  double abilityEnergy1 = 10;
  double abilityEnergy2 = 10;
  double abilityEnergy3 = 10;
  double abilityDamage1 = 10;
  double abilityDamage2 = 10;
  double abilityDamage3 = 10;
  bool usingAbility = false;

  AtlasCharacter({required position, required this.joystick})
      : super(position: position) {
    anchor = Anchor.center;
    size = Vector2.all(characterSize);
    add(
      RectangleHitbox(
        size: Vector2(40, 25),
        position: Vector2((characterSize / 2) - 20, (characterSize / 2) + 5),
      ),
    );
  }

  KeyEventResult moveWithWASD(Set<LogicalKeyboardKey> keysPressed) {
    // calculate vector from WASD keys
    Vector2 directionFromKeys = Vector2(0, 0);
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      directionFromKeys.y--;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      directionFromKeys.x--;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      directionFromKeys.y++;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      directionFromKeys.x++;
    }

    // key is not WASD; ignore
    if (directionFromKeys == Vector2(0, 0)) {
      directionWASD = JoystickDirection.idle;
      return KeyEventResult.ignored;
    }
    // go up
    else if (directionFromKeys == Vector2(0, -1)) {
      directionWASD = JoystickDirection.up;
    }
    // go up-right
    else if (directionFromKeys == Vector2(1, -1)) {
      directionWASD = JoystickDirection.upRight;
    }
    // go right
    else if (directionFromKeys == Vector2(1, 0)) {
      directionWASD = JoystickDirection.right;
    }
    // go down-right
    else if (directionFromKeys == Vector2(1, 1)) {
      directionWASD = JoystickDirection.downRight;
    }
    // go down
    else if (directionFromKeys == Vector2(0, 1)) {
      directionWASD = JoystickDirection.down;
    }
    // go down-left
    else if (directionFromKeys == Vector2(-1, 1)) {
      directionWASD = JoystickDirection.downLeft;
    }
    // go left
    else if (directionFromKeys == Vector2(-1, 0)) {
      directionWASD = JoystickDirection.left;
    }
    // go up-left
    else if (directionFromKeys == Vector2(-1, -1)) {
      directionWASD = JoystickDirection.upLeft;
    }

    // no keys down
    if (keysPressed.isEmpty) {
      directionWASD = JoystickDirection.idle;
      return KeyEventResult.ignored;
    }

    return KeyEventResult.handled;
  }

  void walk({
    required double dt,
    required JoystickDirection directionInput,
    required bool usingJoystick,
    required double movementY,
    required double movementX,
  }) {
    switch (directionInput) {
      case JoystickDirection.idle:
        animation = idleAnimation;
        break;

      case JoystickDirection.up:
        if (!usingJoystick) movementY = -1;

        animation = upAnimation;
        if (y > size.y / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * movementY;
          }
        }
        break;

      case JoystickDirection.upLeft:
        if (!usingJoystick) {
          movementX = -.707;
          movementY = -.707;
        }

        animation = leftAnimation;
        if (y > height / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * movementY;
          }
        }
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * movementX;
          }
        }

        break;

      case JoystickDirection.upRight:
        if (!usingJoystick) {
          movementX = .707;
          movementY = -.707;
        }

        animation = rightAnimation;
        if (y > height / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * movementY;
          }
        }
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * movementX;
          }
        }

        break;

      case JoystickDirection.down:
        animation = downAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * movementY;
          }
        }
        break;

      case JoystickDirection.downLeft:
        if (!usingJoystick) {
          movementX = -.707;
          movementY = .707;
        }

        animation = leftAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * movementY;
          }
        }
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * movementX;
          }
        }
        break;

      case JoystickDirection.downRight:
        if (!usingJoystick) {
          movementX = .707;
          movementY = .707;
        }

        animation = rightAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * movementY;
          }
        }
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * movementX;
          }
        }
        break;

      case JoystickDirection.left:
        if (!usingJoystick) movementX = -1;

        animation = leftAnimation;
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * movementX;
          }
        }
        break;

      case JoystickDirection.right:
        animation = rightAnimation;
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * movementX;
          }
        }
        break;
    }
  }

  void forceAtlasWithinMap() {
    if (x > gameRef.mapWidth - size.x / 3) {
      x -= 2;
    } else if (x < size.x / 3) {
      x += 2;
    }

    if (y > gameRef.mapHeight - size.y / 3) {
      y -= 2;
    } else if (y < size.y / 3) {
      y += 2;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    bool usingJoystick = directionWASD == JoystickDirection.idle;

    JoystickDirection directionInput;
    double movementX = 1;
    double movementY = 1;

    // use joystick input
    if (usingJoystick) {
      directionInput = joystick.direction;
      movementX = joystick.relativeDelta.x;
      movementY = joystick.relativeDelta.y;
    }

    // use WASD input
    else {
      directionInput = directionWASD;
    }

    // update character location based on walk
    walk(
      dt: dt,
      directionInput: directionInput,
      usingJoystick: usingJoystick,
      movementX: movementX,
      movementY: movementY,
    );

    forceAtlasWithinMap();
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
    abilityCooldown1 = 0.5;
    abilityCooldown2 = 20;
    abilityCooldown3 = 5;
    abilityEnergy1 = 5;
    abilityEnergy2 = 70;
    abilityEnergy3 = 30;
    abilityDamage1 = 5;
    abilityDamage2 = 5;
    abilityDamage3 = 0;
  }

  // to display in character selection
  static const abilityHeaders = [
    "Fireball",
    "Arcane Beam",
    "Teleport",
  ];
  static const abilityImagePaths = [
    "assets/images/abilities/fireball.gif",
    "assets/images/abilities/beam.gif",
    "assets/images/abilities/teleport.gif",
  ];

  @override
  bool ability1() {
    if (energy > abilityEnergy1 && !usingAbility) {
      energy -= abilityEnergy1;
      gameRef.add(Fireball(atlas: this, damage: abilityDamage1));
      return true;
    }
    return false;
  }

  @override
  bool ability2() {
    if (energy > abilityEnergy2 && !usingAbility) {
      energy -= abilityEnergy2;
      gameRef.add(Beam(atlas: this, damage: abilityDamage2));
      return true;
    }
    return false;
  }

  @override
  bool ability3() {
    if (energy > abilityEnergy3 && !usingAbility) {
      energy -= abilityEnergy3;
      gameRef.add(Teleport(atlas: this));
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
      energy += energyGain;
    }
  }
}

class Archer extends AtlasCharacter {
  Archer({
    required super.position,
    required super.joystick,
  }) {
    abilityCooldown1 = 0.5;
    abilityCooldown2 = 10;
    abilityCooldown3 = 1;
    abilityEnergy1 = 5;
    abilityEnergy2 = 60;
    abilityEnergy3 = 20;
    abilityDamage1 = 5;
    abilityDamage2 = 30;
    abilityDamage3 = 0;
  }

  // to display in character selection
  static const abilityHeaders = [
    "Arrow Cluster",
    "Rapier Stab",
    "Dash",
  ];
  static const abilityImagePaths = [
    "assets/images/abilities/arrow_cluster.gif",
    "assets/images/abilities/rapier_stab.gif",
    "assets/images/abilities/dash.gif",
  ];

  @override
  ability1() {
    if (energy > abilityEnergy1 && !usingAbility) {
      energy -= abilityEnergy1;
      gameRef.add(ArrowCluster(atlas: this, damage: abilityDamage1));
      return true;
    }
    return false;
  }

  @override
  ability2() {
    if (energy > abilityEnergy2 && !usingAbility) {
      energy -= abilityEnergy2;
      gameRef.add(RapierStab(atlas: this, damage: abilityDamage2));
      return true;
    }
    return false;
  }

  @override
  ability3() {
    if (energy > abilityEnergy3 && !usingAbility) {
      energy -= abilityEnergy3;
      gameRef.add(Dash(atlas: this));
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
      energy += energyGain;
    }
  }
}

class Knight extends AtlasCharacter {
  Knight({
    required super.position,
    required super.joystick,
  }) {
    abilityCooldown1 = 0.5;
    abilityCooldown2 = 15;
    abilityCooldown3 = 10;
    abilityEnergy1 = -5;
    abilityEnergy2 = 30;
    abilityEnergy3 = 20;
    abilityDamage1 = 5;
    abilityDamage2 = 30;
    abilityDamage3 = 10;
  }

  // to display in character selection
  static const abilityHeaders = [
    "Sword",
    "Impact",
    "Whirlwind",
  ];
  static const abilityImagePaths = [
    "assets/images/abilities/sword.gif",
    "assets/images/abilities/impact.gif",
    "assets/images/abilities/whirlwind.gif",
  ];

  @override
  ability1() {
    if (!usingAbility) {
      gameRef.add(Sword(atlas: this, damage: abilityDamage1));
      return true;
    }
    return false;
  }

  @override
  ability2() {
    if (energy > abilityEnergy2 && !usingAbility) {
      energy -= abilityEnergy2;
      gameRef.add(Impact(atlas: this, damage: abilityDamage2));
      return true;
    }
    return false;
  }

  @override
  ability3() {
    if (energy > abilityEnergy3 && !usingAbility) {
      energy -= abilityEnergy3;
      gameRef.add(Whirlwind(atlas: this, damage: abilityDamage3));
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
    if (energy > 0) {
      energy -= energyGain;
    }
  }
}
