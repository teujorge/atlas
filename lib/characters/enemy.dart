import 'dart:math';

import 'package:Atlas/characters/obstacle.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'atlas.dart';
import '../main.dart';
import '../loaders.dart';
import '../abilities/ability.dart';

class EnemyCharacter extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  Dir direction = Dir.idle;
  late Vector2 randomMove;
  final double animationSpeed = .3;
  int health = 100;

  EnemyCharacter() {
    debugMode = true;
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  Vector2 getRandomVector({required max, min = 0, onlyPos = true}) {
    Vector2 randomVector = Vector2(
      Random().nextDouble() * max,
      Random().nextDouble() * max,
    );

    if (!onlyPos) {
      if (Random().nextInt(1) == 0) {
        randomVector.x *= -1;
      }
      if (Random().nextInt(1) == 0) {
        randomVector.y *= -1;
      }
    }

    return randomVector;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = getRandomVector(max: 400, min: 100);
    randomMove = getRandomVector(max: 50, onlyPos: false);
    size = Vector2(50, 50);
    // anim x flip
    if (randomMove.x < 0) {
      flipHorizontally();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ability) {
      print("my health: $health");
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // dead if health = 0;
    if (health <= 0) {
      gameRef.remove(this);
    }
    // alive
    else {
      // current direction
      if (randomMove.x > 0) {
        direction = Dir.right;
      } else if (randomMove.x < 0) {
        direction = Dir.left;
      }

      // switch x vel
      if (position.x + 25 > gameRef.mapWidth) {
        randomMove.x *= -1;
      } else if (position.x < 25) {
        randomMove.x *= -1;
      }

      // switch y vel
      if (position.y + 25 > gameRef.mapHeight) {
        randomMove.y *= -1;
      } else if (position.y < 25) {
        randomMove.y *= -1;
      }

      // move
      position.add(randomMove * dt);

      // anim x flip
      if (randomMove.x > 0 && direction == Dir.left) {
        flipHorizontallyAroundCenter();
      } else if (randomMove.x < 0 && direction == Dir.right) {
        flipHorizontallyAroundCenter();
      }
    }
  }
}

class Skelet extends EnemyCharacter {
  Skelet();
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "enemies/skelet.png",
      0.15,
    );
  }
}

class Necro extends EnemyCharacter {
  Necro();
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "enemies/necro.png",
      0.15,
    );
  }
}
