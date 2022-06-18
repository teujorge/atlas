import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../abilities/ability.dart';

class Hud extends Component with HasGameRef<AtlasGame> {
  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  Future<void>? onLoad() {
    final scoreTextComponent = TextComponent(
      text: 'Score: 0',
      position: Vector2.all(10),
    );
    add(scoreTextComponent);

    final healthTextComponent = TextComponent(
      text: 'x5',
      position: Vector2(10, 50),
    );
    add(healthTextComponent);

    gameRef.atlas.kills.addListener(() {
      scoreTextComponent.text = 'Score: ${gameRef.atlas.kills.value}';
    });

    gameRef.atlas.health.addListener(() {
      healthTextComponent.text = 'x${gameRef.atlas.health.value}';
    });

    add(AbilityButton(
      position: Vector2(
        gameRef.size.x - 125,
        gameRef.size.y - 125,
      ),
    ));

    add(
      PauseButton(
        position: Vector2(gameRef.size.x - 50, 10),
      ),
    );

    return super.onLoad();
  }
}

class PauseButton extends PositionComponent
    with Tappable, HasGameRef<AtlasGame> {
  static final Paint _white = Paint()..color = Color.fromARGB(255, 255, 5, 5);

  // bool _beenPressed = false;

  PauseButton({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(50),
        );

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _white);
  }

  @override
  bool onTapDown(_) {
    if (gameRef.paused) {
      gameRef.resumeEngine();
    } else {
      gameRef.pauseEngine();
    }

    return true;
  }
}
