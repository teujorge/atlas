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
  final abilityMargin1 = const EdgeInsets.only(bottom: 125, right: 25);
  final abilityMargin2 = const EdgeInsets.only(bottom: 25, right: 125);
  final abilityMargin3 = const EdgeInsets.only(bottom: 75, right: 75);

  late Color energyColor;

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
    // change ability button colors
    energyColor = const Color.fromARGB(255, 6, 54, 158);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
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
      Paint()..color = energyColor,
    );
  }

  @override
  Future<void>? onLoad() {
    super.onLoad();
    // score
    final scoreTextComponent = TextComponent(
      text: 'Score: 0',
      position: Vector2(game.mapWidth - 225, 10),
    );
    add(scoreTextComponent);
    game.atlas.kills.addListener(() {
      scoreTextComponent.text = 'Score: ${game.atlas.kills.value}';
    });

    // change ability button colors
    if (game.atlas is Mage) {
      energyColor = Colors.purple;
    }
    if (game.atlas is Knight) {
      energyColor = Colors.orange;
    }
    if (game.atlas is Archer) {
      energyColor = Colors.yellow;
    }
    // add abilities buttons
    add(
      // ability 1
      AbilityButton(
        game: game,
        abilityWhich: 1,
        margin: abilityMargin1,
      ),
    );
    add(
      // ability 2
      AbilityButton(
        game: game,
        abilityWhich: 2,
        margin: abilityMargin2,
      ),
    );
    add(
      // ability 3
      AbilityButton(
        game: game,
        abilityWhich: 3,
        margin: abilityMargin3,
      ),
    );

    // joystick
    add(joystick);

    // settings
    add(
      PauseButton(
        margin: const EdgeInsets.only(top: 20, right: 20),
        // image: Image.asset('collectables/potion.png'),
        context: context,
      ),
    );

    return super.onLoad();
  }
}

class HudButton extends HudMarginComponent with Tappable {
  final Paint outlinePaintColor = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0);
  final Paint disableBackground = Paint()
    ..color = const Color.fromARGB(150, 255, 5, 5);
  final Paint ableBackground = Paint()
    ..color = const Color.fromARGB(150, 80, 255, 5);
  Paint background = Paint()..color = const Color.fromARGB(150, 80, 255, 5);
  ui.Image? image;

  HudButton({
    required EdgeInsets margin,
    this.image,
  }) : super(
          margin: margin,
          size: Vector2.all(50),
        ) {}

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (image != null) {
      canvas.drawImage(image!, const Offset(0, 0), background);
    } else {
      canvas.drawRect(size.toRect(), background);
    }
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, size.y),
      outlinePaintColor,
    );
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.y, 0),
      outlinePaintColor,
    );
    canvas.drawLine(
      Offset(0, size.y),
      Offset(size.y, size.y),
      outlinePaintColor,
    );
    canvas.drawLine(
      Offset(size.y, 0),
      Offset(size.y, size.y),
      outlinePaintColor,
    );
  }
}

class PauseButton extends HudButton {
  BuildContext context;
  PauseButton({required EdgeInsets margin, required this.context, image})
      : super(margin: margin, image: image);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);
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
  late Timer cooldown;
  bool onCooldown = false;
  late Function abilityFn;
  final int abilityWhich;
  late final double abilityEnergy;

  AbilityButton({
    image,
    required this.game,
    required EdgeInsets margin,
    required this.abilityWhich,
  }) : super(margin: margin, image: image) {
    double cooldownTime = 2;
    switch (abilityWhich) {
      case 1:
        cooldownTime = game.atlas.abilityCooldown1;
        abilityEnergy = game.atlas.abilityEnergy1;
        abilityFn = game.atlas.ability1;
        break;
      case 2:
        cooldownTime = game.atlas.abilityCooldown2;
        abilityEnergy = game.atlas.abilityEnergy2;
        abilityFn = game.atlas.ability2;
        break;
      case 3:
        cooldownTime = game.atlas.abilityCooldown3;
        abilityEnergy = game.atlas.abilityEnergy3;
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
    super.onTapDown(info);
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
      Vector2(size.x - cooldown.progress * size.x, 5).toRect(),
      Paint()..color = const Color.fromARGB(255, 255, 255, 255),
    );
    // canvas.drawCircle(
    //   Offset(size.x / 2, size.y / 2),
    //   25,
    //   background,
    // );
  }

  @override
  void update(double dt) {
    super.update(dt);
    cooldown.update(dt);

    bool notEnoughEnergy = false;
    if (abilityEnergy > game.atlas.energy) {
      notEnoughEnergy = true;
    }

    if (onCooldown || notEnoughEnergy) {
      background = disableBackground;
    } else {
      background = ableBackground;
    }
  }
}
