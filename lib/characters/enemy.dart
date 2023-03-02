import 'package:Atlas/characters/atlas.dart';
import 'package:Atlas/collectables/collectables.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'dart:ui';
import 'dart:math';

import '../main.dart';
import '../loaders.dart';
import '../abilities/ability.dart';

class EnemyCharacter extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  Dir direction = Dir.idle;
  Vector2 atlasDirection = Vector2(0, 0);
  Vector2 moveDirection = Vector2(0, 0);
  double moveSpeed = 25;
  final double animationSpeed = .3;
  double health = 100;
  double maxHealth = 100;

  EnemyCharacter() {
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  Vector2 getRandomSpawnVector() {
    Vector2 randomVector = Vector2(
      Random().nextDouble() * gameRef.mapWidth,
      Random().nextDouble() * gameRef.mapHeight * 0.1 + gameRef.mapHeight,
    );
    return randomVector;
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
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(
      Vector2(size.x * health / maxHealth, -5).toRect(),
      Paint()..color = const Color.fromARGB(255, 255, 0, 0),
    );
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = getRandomSpawnVector();
    size = Vector2(50, 50);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ability) {
      // print("my health: $health");
    }
    if (other is AtlasCharacter) {
      other.position += atlasDirection * 0.01;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // dead if health = 0;
    if (health <= 0) {
      if (Random().nextInt(51) == 10) {
        gameRef.add(HealthPotion(position: position));
      } else if (Random().nextInt(51) == 10) {
        gameRef.add(EnergyPotion(position: position));
      }
      gameRef.atlas.kills.value++;
      gameRef.remove(this);
    }

    // alive
    else {
      // get atlas vector
      atlasDirection =
          Vector2(gameRef.atlas.x, gameRef.atlas.y) - Vector2(x, y);
      // get door vector
      Vector2 doorDirection =
          Vector2(gameRef.doorPosition.x, gameRef.doorPosition.y) -
              Vector2(x, y);

      // go to shortest objective
      if (atlasDirection.length < doorDirection.length) {
        moveDirection = atlasDirection;
      } else {
        moveDirection = doorDirection;
      }
      moveDirection /= moveDirection.length;

      // move
      position.add(moveDirection * moveSpeed * dt);

      // anim x flip
      if (atlasDirection.x > 0 && direction == Dir.left) {
        flipHorizontallyAroundCenter();
      } else if (atlasDirection.x < 0 && direction == Dir.right) {
        flipHorizontallyAroundCenter();
      }
    }
  }
}

class Skelet extends EnemyCharacter {
  Skelet() {
    health = maxHealth = 125;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "enemies/skelet.png",
      0.15,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      other.health -= 0.10;
    }
  }
}

class Necro extends EnemyCharacter {
  Necro() {
    health = maxHealth = 200;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "enemies/necro.png",
      0.15,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      other.health -= 0.25;
    }
  }
}

class Goblin extends EnemyCharacter {
  Goblin();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    animation = await createAnimation(
      gameRef,
      "enemies/goblin.png",
      0.15,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AtlasCharacter) {
      other.health -= 0.50;
    }
  }
}
