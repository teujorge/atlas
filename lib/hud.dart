import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'main.dart';
import 'loaders.dart';
import 'screens/options.dart';
import '../characters/atlas.dart';

class Hud extends Component {
// game and app
  late final BuildContext context;
  final AtlasGame game;

  // movement and slected character
  late final JoystickComponent joystick;

  late final CharName character;

  // 3 ability buttons locations (margins)
  final abilityMargin1 = const EdgeInsets.only(bottom: 75, right: 25);
  final abilityMargin2 = const EdgeInsets.only(bottom: 25, right: 75);
  final abilityMargin3 = const EdgeInsets.only(bottom: 75, right: 75);

  Hud({
    super.children,
    super.priority,
    required this.game,
    required this.context,
    required this.character,
  }) {
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
  void render(Canvas canvas) {
    // atlas health bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, game.atlas.health * 2, 50),
        Radius.circular(game.atlas.health),
      ),
      Paint()..color = const Color.fromARGB(255, 255, 10, 10),
    );
    // atlas energy bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 50, game.atlas.energy * 2, 50),
        Radius.circular(game.atlas.energy),
      ),
      Paint()..color = const Color.fromARGB(255, 100, 50, 200),
    );
  }

  @override
  Future<void>? onLoad() {
    // score
    final scoreTextComponent = TextComponent(
      text: 'Score: 0',
      position: Vector2(game.mapWidth - 225, 10),
    );
    add(scoreTextComponent);
    game.atlas.kills.addListener(() {
      scoreTextComponent.text = 'Score: ${game.atlas.kills.value}';
    });

    // add abilities buttons
    add(
      // ability 1
      AbilityButton(
        game: game,
        ability: 1,
        margin: abilityMargin1,
      ),
    );
    add(
      // ability 2
      AbilityButton(
        game: game,
        ability: 2,
        margin: abilityMargin2,
      ),
    );
    add(
      // ability 3
      AbilityButton(
        game: game,
        ability: 3,
        margin: abilityMargin3,
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
  final Paint redBackground = Paint()
    ..color = const Color.fromARGB(150, 255, 5, 5);
  final Paint greenBackground = Paint()
    ..color = const Color.fromARGB(150, 80, 255, 5);
  Paint background = Paint()..color = const Color.fromARGB(150, 80, 255, 5);
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
  PauseButton({
    required EdgeInsets margin,
    required this.context,
  }) : super(margin: margin);

  @override
  void render(Canvas canvas) {
    if (gameRef.paused) {
      canvas.drawLine(const Offset(-20, 0), const Offset(20, 0), redBackground);
    } else {
      canvas.drawLine(const Offset(0, -20), const Offset(0, 20), redBackground);
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    // enter settings

    gameRef.pauseEngine();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Options(game: gameRef),
      ),
    );

    return true;
  }
}

// https://medium.com/flutteropen/canvas-tutorial-01-how-to-use-the-canvas-in-the-flutter-8aade29ddc9
class AbilityButton extends HudButton {
  AtlasGame game;
  bool onCooldown = false;
  late Timer cooldown;
  late Function abilityFn;

  AbilityButton({
    required EdgeInsets margin,
    required ability,
    required this.game,
  }) : super(margin: margin) {
    double cooldownTime = 2;
    switch (ability) {
      case 1:
        cooldownTime = game.atlas.abilityCooldown1;
        abilityFn = game.atlas.ability1;
        break;
      case 2:
        cooldownTime = game.atlas.abilityCooldown2;
        abilityFn = game.atlas.ability2;
        break;
      case 3:
        cooldownTime = game.atlas.abilityCooldown3;
        abilityFn = game.atlas.ability3;
        break;
    }
    cooldown = Timer(
      cooldownTime,
      onTick: () {
        onCooldown = false;
      },
      repeat: false,
      autoStart: false,
    );
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (!onCooldown) {
      bool abilityUsed = abilityFn();
      // if ability was used start cooldown
      if (abilityUsed) {
        onCooldown = true;
        cooldown.start();
      }
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // cooldown progress
    canvas.drawRect(
      Vector2(50 - cooldown.progress * size.x, 5).toRect(),
      Paint()..color = const Color.fromARGB(255, 255, 255, 255),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    cooldown.update(dt);
    if (onCooldown) {
      background = redBackground;
    } else {
      background = greenBackground;
    }
  }
}
