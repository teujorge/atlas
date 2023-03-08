import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class DefendDoor extends PositionComponent {
  double health = 100;
  late RectangleHitbox hitbox;

  DefendDoor(double mapWidth) {
    debugMode = true;
    anchor = Anchor.topCenter;
    size = Vector2(200, 20);
    position = Vector2(
      mapWidth / 2,
      0,
    );

    hitbox = RectangleHitbox(
      size: size,
    );
  }

  @override
  FutureOr<void> onLoad() {
    add(hitbox);
    return super.onLoad();
  }
}
