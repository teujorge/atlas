import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'ability.dart';
import '../loaders.dart';

// // Mage Abilities // //

// throw ball of fire
class Fireball extends ThrownAbility {
  Fireball({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
    add(CircleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/fireball.png",
      animationStep,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += dt * 2;
  }
}

// throw ball of ice
class Iceball extends ThrownAbility {
  Iceball({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
    add(CircleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/iceball.png",
      animationStep,
    );
  }
}

// beam of arcane
class Beam extends MeleeAbility {
  Beam({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
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

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/beam.png",
      animationStep,
    );
  }
}

// // Archer Abilities // //

class Arrow extends ThrownAbility {
  Arrow({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
    add(RectangleHitbox(
      anchor: Anchor.topCenter,
      size: Vector2(size.x / 5, size.y / 2),
      position: Vector2(position.x + (size.x / 2), position.y),
    ));
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/arrow.png",
      animationStep,
    );
  }
}

class Cluster extends ThrownAbility {
  Cluster({
    required super.atlas,
    super.animationStep,
    super.damage,
  }) {
    add(RectangleHitbox());
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/cluster.png",
      animationStep,
    );
  }
}

class GreenHit extends MeleeAbility {
  GreenHit({
    required super.atlas,
    super.animationStep,
    super.damage,
    super.meleeCycles,
  }) {
    anchor = Anchor.topCenter;
    meleeCycles *= 5;
    size *= 2;
    add(RectangleHitbox(
      anchor: Anchor.topCenter,
      size: Vector2(size.x / 5, size.y),
      position: Vector2(position.x + (size.x / 2), position.y),
    ));
  }
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/green_hit.png",
      animationStep,
    );
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
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/whirlwind.png",
      animationStep,
    );
  }
}

class Impact extends MeleeAbility {
  Impact({
    required super.atlas,
    super.animationStep,
    super.damage,
    super.meleeCycles,
  }) {
    anchor = Anchor.topCenter;
    size *= 2;
    meleeCycles *= 4;
    add(RectangleHitbox(
      anchor: Anchor.topCenter,
      size: Vector2(size.x / 3, size.y),
      position: Vector2(position.x + (size.x / 2), position.y),
    ));
  }
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/impact.png",
      animationStep,
    );
  }
}

class Sword extends MeleeAbility {
  Sword({
    required super.atlas,
    super.animationStep,
    super.damage,
    super.meleeCycles,
  }) {
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

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "abilities/sword.png",
      animationStep,
    );
  }
}

class Teleport extends DashAbility {
  Teleport({
    required super.atlas,
    super.animationStep,
  });
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    atlas.position = atlas.position + newPosition;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    gameRef.remove(this);
  }
}
