import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';

class AtlasCharacter extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<AtlasGame> {
  // score
  final kills = ValueNotifier<int>(0);
  final health = ValueNotifier<int>(100);

  // char movement
  late String character;
  final double animationSpeed = .3;
  final double characterSize = 60;
  final double characterSpeed = 80;
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation idleAnimation;
  final JoystickComponent joystick;
  List<JoystickDirection> collisionDirections = [];

  AtlasCharacter(
      {required position, required this.character, required this.joystick})
      : super(position: position) {
    debugMode = true;
    anchor = Anchor.center;
    size = Vector2.all(characterSize);
    add(
      RectangleHitbox(
        size: Vector2(40, 25),
        position: Vector2((characterSize / 2) - 20, (characterSize / 2) + 5),
      ),
    );
  }
  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    downAnimation = SpriteSheet(
      image: await gameRef.images.load("atlas/mage_down.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 4,
    );
    leftAnimation = SpriteSheet(
      image: await gameRef.images.load("atlas/mage_left.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 4,
    );
    upAnimation = SpriteSheet(
      image: await gameRef.images.load("atlas/mage_up.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 4,
    );
    rightAnimation = SpriteSheet(
      image: await gameRef.images.load("atlas/mage_right.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: animationSpeed,
      to: 4,
    );
    idleAnimation = SpriteSheet(
      image: await gameRef.images.load("atlas/mage_idle.png"),
      srcSize: Vector2(32, 32),
    ).createAnimation(
      row: 0,
      stepTime: .8,
      to: 4,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // update caharacter location based on walk
    switch (joystick.direction) {
      case JoystickDirection.idle:
        animation = idleAnimation;
        break;

      case JoystickDirection.up:
        animation = upAnimation;
        if (y > size.y / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        break;

      case JoystickDirection.upLeft:
        animation = leftAnimation;
        if (y > height / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }

        break;

      case JoystickDirection.upRight:
        animation = rightAnimation;

        if (y > height / 2) {
          if (!collisionDirections.contains(JoystickDirection.up)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }

        break;

      case JoystickDirection.down:
        animation = downAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        break;

      case JoystickDirection.downLeft:
        animation = leftAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;

      case JoystickDirection.downRight:
        animation = rightAnimation;
        if (y < gameRef.mapHeight - height / 2) {
          if (!collisionDirections.contains(JoystickDirection.down)) {
            y += dt * characterSpeed * joystick.relativeDelta.y;
          }
        }
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;

      case JoystickDirection.left:
        animation = leftAnimation;
        if (x > width / 2) {
          if (!collisionDirections.contains(JoystickDirection.left)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;

      case JoystickDirection.right:
        animation = rightAnimation;
        if (x < gameRef.mapWidth - width / 2) {
          if (!collisionDirections.contains(JoystickDirection.right)) {
            x += dt * characterSpeed * joystick.relativeDelta.x;
          }
        }
        break;
    }
  }
}
