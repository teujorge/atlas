// import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../characters/atlas.dart';
import '../main.dart';

class ItemsCollectables extends SpriteComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  ItemsCollectables({required super.position}) {
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  // }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    size = Vector2(50, 50);
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);
  // }
}

class HealthPotion extends ItemsCollectables {
  final quantity = 30;
  HealthPotion({required super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite("collectables/potion.png");
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      if (gameRef.atlas.health < 100) {
        if (gameRef.atlas.health + quantity > 100) {
          gameRef.atlas.health = 100;
        } else {
          gameRef.atlas.health += quantity;
        }

        gameRef.remove(this);
      }
    }
  }
}

class EnergyPotion extends ItemsCollectables {
  final quantity = 30;
  EnergyPotion({required super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite("collectables/energy.png");
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      if (gameRef.atlas.energy < 100) {
        if (gameRef.atlas.energy + quantity > 100) {
          gameRef.atlas.energy = 100;
        } else {
          gameRef.atlas.energy += quantity;
        }

        gameRef.remove(this);
      }
    }
  }
}
