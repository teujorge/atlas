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
      anchor: Anchor.topRight,
      position: Vector2(gameRef.size.x - 10, 10),
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

    return super.onLoad();
  }
}
