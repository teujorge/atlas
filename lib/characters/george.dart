import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../main.dart';

class GeorgeComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<GeorgeGame> {
  Direction direction = Direction.idle;

  int collisionDirection = -1;

  final double animationSpeed = .1;
  final double characterSize = 50;
  final double characterSpeed = 80;
  //0 =idle, 1=down, 2=left, 3=up, 4=right
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;

  GeorgeComponent({required position}) : super(position: position) {
    debugMode = true;
    size = Vector2.all(characterSize);
    add(
      RectangleHitbox(
        size: Vector2.all(40),
      ),
    );
  }
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load("george2.png"),
      srcSize: Vector2(48, 48),
    );

    downAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 4,
    );
    leftAnimation = SpriteSheet(
      image: await gameRef.images.load("mage_left.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: .3,
      to: 4,
    );
    upAnimation = spriteSheet.createAnimation(
      row: 2,
      stepTime: animationSpeed,
      to: 4,
    );
    rightAnimation = SpriteSheet(
      image: await gameRef.images.load("mage_right.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: .3,
      to: 4,
    );
    idleAnimation = SpriteSheet(
      image: await gameRef.images.load("mage_idle.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: .8,
      to: 4,
    );
  }

  //0 =idle, 1=down, 2=left, 3=up, 4=right
  @override
  void update(double dt) {
    super.update(dt);
    // update caharacter location based on walk
    switch (direction) {
      case Direction.idle:
        animation = idleAnimation;
        break;

      case Direction.up:
        animation = upAnimation;
        if (y > 0) {
          if (collisionDirection != 3) {
            y -= dt * characterSpeed;
          }
        }
        break;

      case Direction.down:
        animation = downAnimation;
        if (y < gameRef.mapHeight - height) {
          if (collisionDirection != 1) {
            y += dt * characterSpeed;
          }
        }
        break;

      case Direction.left:
        animation = leftAnimation;
        if (x > 0) {
          if (collisionDirection != 2) {
            x -= dt * characterSpeed;
          }
        }
        break;

      case Direction.right:
        animation = rightAnimation;
        if (x < gameRef.mapWidth - width) {
          if (collisionDirection != 4) {
            x += dt * characterSpeed;
          }
        }
        break;
    }
  }
}
