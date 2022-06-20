import 'ability.dart';

// throw ball of fire
class Fireball extends ThrownAbility {
  Fireball({required super.direction, super.animationStep});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation("abilities/fireball.png");
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
    animation = await createAnimation("abilities/iceball.png");
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
    animation = await createAnimation("abilities/whirlwind.png");
  }
}
