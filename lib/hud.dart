import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'main.dart';
import 'screens/options.dart';
import 'abilities/abilities.dart';

class Hud extends Component with HasGameRef<AtlasGame> {
  late JoystickComponent joystick;
  late BuildContext context;

  Hud({super.children, super.priority, required this.context}) {
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
      margin: const EdgeInsets.only(left: 40, bottom: 40),
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
        margin: const EdgeInsets.only(bottom: 25, right: 75),
        abilityType: Fireball,
        joystick: joystick,
      ),
    );

    // ability 2
    add(
      AbilityButton(
        margin: const EdgeInsets.only(bottom: 75, right: 25),
        abilityType: Iceball,
        joystick: joystick,
      ),
    );

    // ability 3
    add(
      AbilityButton(
        margin: const EdgeInsets.only(bottom: 75, right: 75),
        abilityType: Whirlwind,
        joystick: joystick,
      ),
    );

    // joystick
    add(joystick);

    // settings
    add(
      PauseButton(
        margin: const EdgeInsets.only(top: 20, right: 20),
        context: context,
      ),
    );

    return super.onLoad();
  }
}

class HudButton extends HudMarginComponent with Tappable {
  Paint background = Paint()
    ..color = const Color.fromARGB(255, 255, 5, 5).withAlpha(150);
  ui.Image? image;

  HudButton({
    required EdgeInsets margin,
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
  BuildContext context;
  PauseButton({required EdgeInsets margin, required this.context})
      : super(
          margin: margin,
        );

  @override
  void render(Canvas canvas) {
    if (gameRef.paused) {
      canvas.drawLine(const Offset(-20, 0), const Offset(20, 0), background);
    } else {
      canvas.drawLine(const Offset(0, -20), const Offset(0, 20), background);
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    // exit settings
    if (gameRef.paused) {
      gameRef.resumeEngine();
    }
    // enter settings
    else {
      gameRef.pauseEngine();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Options(),
        ),
      );
    }
    return true;
  }
}

// https://medium.com/flutteropen/canvas-tutorial-01-how-to-use-the-canvas-in-the-flutter-8aade29ddc9
class AbilityButton extends HudButton {
  late Type abilityType;
  late JoystickComponent joystick;
  AbilityButton({
    required EdgeInsets margin,
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
      case Whirlwind:
        print("whirlwind");
        gameRef.add(Whirlwind(direction: joystick.direction));
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
