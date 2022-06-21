import 'package:flame/components.dart';

import 'ability.dart';
import '../loaders.dart';

// // Mage Abilities // //

// throw ball of fire
class Fireball extends ThrownAbility {
  Fireball({required super.direction, super.animationStep});

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
  Iceball({required super.direction, super.animationStep});

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
  Beam({required super.direction, super.animationStep}) {
    anchor = Anchor.topCenter;
    meleeCycles *= 10;
    size *= 4;
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
  Arrow({required super.direction, super.animationStep});

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
  Cluster({required super.direction, super.animationStep});

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

// // Knight Abilities // //

// spin around with sword
class Whirlwind extends MeleeAbility {
  Whirlwind(
      {required super.direction, super.animationStep, super.meleeCycles}) {
    size *= 2;
    meleeCycles *= 5;
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
  Impact({required super.direction, super.animationStep, super.meleeCycles}) {
    size *= 2;
    anchor = Anchor.topCenter;
    meleeCycles *= 5;
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
  Sword({required super.direction, super.animationStep, super.meleeCycles}) {
    size *= 2;
    anchor = Anchor.topCenter;
    meleeCycles *= 5;
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

class GreenHit extends MeleeAbility {
  GreenHit({required super.direction, super.animationStep, super.meleeCycles}) {
    size *= 2;
    anchor = Anchor.topCenter;
    meleeCycles *= 5;
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
