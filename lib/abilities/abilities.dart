import 'ability.dart';
import '../loaders.dart';

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
