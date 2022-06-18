import 'dart:ui';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' as matl;

import '../main.dart';
import '../abilities/ability.dart';

class Hud extends Component with HasGameRef<AtlasGame> {
  late JoystickComponent joystick;

  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;

    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 25,
        paint: BasicPalette.blue.withAlpha(200).paint(),
      ),
      background: CircleComponent(
        radius: 75,
        paint: BasicPalette.blue.withAlpha(100).paint(),
      ),
      margin: const matl.EdgeInsets.only(left: 40, bottom: 40),
    );
  }

  @override
  Future<void>? onLoad() {
    // score
    final scoreTextComponent = TextComponent(
      text: 'Score: 0',
      position: Vector2.all(10),
    );
    add(scoreTextComponent);
    gameRef.atlas.kills.addListener(() {
      scoreTextComponent.text = 'Score: ${gameRef.atlas.kills.value}';
    });

    // health
    final healthTextComponent = TextComponent(
      text: 'x5',
      position: Vector2(10, 50),
    );
    add(healthTextComponent);
    gameRef.atlas.health.addListener(() {
      healthTextComponent.text = 'x${gameRef.atlas.health.value}';
    });

    // ability 1
    add(
      AbilityButton(
        margin: const matl.EdgeInsets.only(bottom: 25, right: 75),
        abilityType: Fireball,
        joystick: joystick,
      ),
    );

    // ability 2
    add(
      AbilityButton(
        margin: const matl.EdgeInsets.only(bottom: 75, right: 25),
        abilityType: Iceball,
        joystick: joystick,
      ),
    );

    // joystick
    add(joystick);

    // settings
    add(
      PauseButton(
        margin: const matl.EdgeInsets.only(top: 20, right: 20),
      ),
    );

    return super.onLoad();
  }
}

class HudButton extends HudMarginComponent with Tappable {
  Paint background = Paint()
    ..color = const Color.fromARGB(255, 255, 5, 5).withAlpha(150);
  Image? image;

  HudButton({
    required matl.EdgeInsets margin,
    this.image,
  }) : super(
          margin: margin,
          size: Vector2.all(50),
        ) {
    debugMode = true;
  }

  @override
  void render(Canvas canvas) {
    if (image != null) {
      canvas.drawImage(image!, const Offset(0, 0), background);
    } else {
      canvas.drawRect(size.toRect(), background);
    }
  }
}

class PauseButton extends HudButton {
  PauseButton({required matl.EdgeInsets margin})
      : super(
          margin: margin,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    if (gameRef.paused) {
      gameRef.resumeEngine();
    } else {
      gameRef.pauseEngine();
    }

    return true;
  }
}

// https://medium.com/flutteropen/canvas-tutorial-01-how-to-use-the-canvas-in-the-flutter-8aade29ddc9
class AbilityButton extends HudButton {
  late Type abilityType;
  late JoystickComponent joystick;
  AbilityButton({
    required matl.EdgeInsets margin,
    required this.abilityType,
    required this.joystick,
  }) : super(
          margin: margin,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    switch (abilityType) {
      case Fireball:
        print("fireball");
        gameRef.add(Fireball(direction: joystick.direction));
        break;
      case Iceball:
        print("iceball");
        gameRef.add(Iceball(direction: joystick.direction));
        break;
      default:
        print(
          "ABILITY BUTTON SWITCH DEFAULT CASE: ability type not recognized!!!",
        );
        break;
    }

    return true;
  }
}
