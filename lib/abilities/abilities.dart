import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'ability.dart';

// // Mage Abilities // //

class Fireball extends ThrownAbility {
  Fireball({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
    pushSpeed = 2;
    animationFile = "abilities/fireball.png";
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += dt * 2;
  }
}

class Beam extends MeleeAbility {
  Beam({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
    animationFile = "abilities/beam.png";
    anchor = Anchor.topCenter;
    meleeCycles *= 50;
    size *= 4;
    add(RectangleHitbox(
      anchor: Anchor.topCenter,
      size: Vector2(size.x / 8, size.y),
      position: Vector2(position.x + (size.x / 2), position.y),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle = joystickAngle();
  }
}

class Teleport extends MoveAbility {
  Teleport({
    required super.atlas,
    super.animationStep,
    super.distance = 250,
    super.speed = 0,
  }) {
    animationFile = "abilities/teleport.png";
  }
}

// // Archer Abilities // //

class ArrowCluster extends ThrownAbility {
  ArrowCluster({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
    animationFile = "abilities/arrow_cluster.png";
    add(RectangleHitbox());
  }
}

class RapierStab extends MeleeAbility {
  RapierStab({
    required super.atlas,
    super.animationStep,
    super.damage,
    super.meleeCycles,
  }) {
    animationFile = "abilities/rapier_stab.png";
    anchor = Anchor.topCenter;
    meleeCycles *= 10;
    size *= 2;
    add(RectangleHitbox(
      anchor: Anchor.topCenter,
      size: Vector2(size.x / 5, size.y),
      position: Vector2(position.x + (size.x / 2), position.y),
    ));
  }
}

class Dash extends MoveAbility {
  Dash({
    required super.atlas,
    super.animationStep,
    super.distance,
  }) {
    animationFile = "abilities/dash.png";
  }

  void positionSprite() {
    JoystickDirection dir = atlas.directionWASD;
    if (atlas.directionWASD == JoystickDirection.idle) {
      dir = atlas.joystick.direction;
    }

    if (dir == JoystickDirection.left ||
        dir == JoystickDirection.upLeft ||
        dir == JoystickDirection.downLeft) {
      angle = 180 * 3.14 / 180;
      offset = Vector2(0, atlas.height / 2);
    } else if (dir == JoystickDirection.right ||
        dir == JoystickDirection.upRight ||
        dir == JoystickDirection.downRight) {
      angle = 0;
      offset = Vector2(0, 0);
    } else if (dir == JoystickDirection.up) {
      angle = -90 * 3.14 / 180;
      offset = Vector2(-atlas.width / 4, atlas.height / 4);
    } else {
      angle = 90 * 3.14 / 180;
      offset = Vector2(atlas.width / 4, -atlas.height / 4);
    }
  }

  @override
  void updateTree(double dt) {
    positionSprite();
    super.updateTree(dt);
  }
}

// // Knight Abilities // //

class Whirlwind extends MeleeAbility {
  Whirlwind({
    required super.atlas,
    super.animationStep,
    super.damage,
    super.meleeCycles,
  }) {
    animationFile = "abilities/whirlwind.png";
    meleeCycles *= 5;
    size *= 2;
    add(CircleHitbox(
      anchor: Anchor.center,
      radius: size.x / 2,
      position: Vector2(position.x + size.x / 2, position.y + size.y / 2),
    ));
    add(CircleHitbox(
      anchor: Anchor.center,
      radius: size.x / 3,
      position: Vector2(position.x + size.x / 2, position.y + size.y / 2),
    ));
    add(CircleHitbox(
      anchor: Anchor.center,
      radius: size.x / 4,
      position: Vector2(position.x + size.x / 2, position.y + size.y / 2),
    ));
  }
}

class Impact extends MeleeAbility {
  Impact({
    required super.atlas,
    super.animationStep,
    super.damage,
    super.meleeCycles,
  }) {
    animationFile = "abilities/impact.png";
    anchor = Anchor.topCenter;
    size *= 2;
    meleeCycles *= 4;
    add(RectangleHitbox(
      anchor: Anchor.topCenter,
      size: Vector2(size.x / 3, size.y),
      position: Vector2(position.x + (size.x / 2), position.y),
    ));
  }
}

class Sword extends MeleeAbility {
  Sword({
    required super.atlas,
    super.animationStep,
    super.damage,
    super.meleeCycles,
  }) {
    animationFile = "abilities/sword.png";
    anchor = Anchor.topCenter;
    meleeCycles *= 5;
    size *= 2;
    add(RectangleHitbox(
      anchor: Anchor.topCenter,
      size: Vector2(size.x, size.y / 3),
      position: Vector2(position.x + (size.x / 2), position.y + (size.y / 3)),
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (gameRef.atlas.energy < 100) {
      if (gameRef.atlas.energy + gameRef.atlas.energyGain > 100) {
        gameRef.atlas.energy = 100;
      } else {
        gameRef.atlas.energy += gameRef.atlas.energyGain * 4;
      }
    }
  }
}
