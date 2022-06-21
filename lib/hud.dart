import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'main.dart';
import 'loaders.dart';
import 'screens/options.dart';
import 'abilities/abilities.dart';

class Hud extends Component with HasGameRef<AtlasGame> {
  // movement, app context and slected character
  late final JoystickComponent joystick;
  late final BuildContext context;
  late final CharName character;

  // 3 ability buttons locations (margins)
  final abilityMargin1 = const EdgeInsets.only(bottom: 75, right: 25);
  final abilityMargin2 = const EdgeInsets.only(bottom: 25, right: 75);
  final abilityMargin3 = const EdgeInsets.only(bottom: 75, right: 75);

  // list of characters' abilities
  late final List<AbilityButton> characterAbilities;

  Hud({
    super.children,
    super.priority,
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

    switch (character) {
      case CharName.mage:
        characterAbilities = [
          AbilityButton(
            margin: abilityMargin1,
            abilityType: Fireball,
            joystick: joystick,
          ),
          AbilityButton(
            margin: abilityMargin2,
            abilityType: Iceball,
            joystick: joystick,
          ),
          AbilityButton(
            margin: abilityMargin3,
            abilityType: Beam,
            joystick: joystick,
          ),
        ];
        break;
      case CharName.archer:
        characterAbilities = [
          AbilityButton(
            margin: abilityMargin1,
            abilityType: Arrow,
            joystick: joystick,
          ),
          AbilityButton(
            margin: abilityMargin2,
            abilityType: Cluster,
            joystick: joystick,
          ),
          AbilityButton(
            margin: abilityMargin3,
            abilityType: GreenHit,
            joystick: joystick,
          ),
        ];
        break;
      case CharName.knight:
        characterAbilities = [
          AbilityButton(
            margin: abilityMargin3,
            abilityType: Whirlwind,
            joystick: joystick,
          ),
          AbilityButton(
            margin: abilityMargin2,
            abilityType: Impact,
            joystick: joystick,
          ),
          AbilityButton(
            margin: abilityMargin1,
            abilityType: Sword,
            joystick: joystick,
          ),
        ];
        break;
    }
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

    // add abilities (character dependant)
    for (AbilityButton ab in characterAbilities) {
      add(ab);
    }

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
    ..color = const Color.fromARGB(255, 255, 5, 5).withAlpha(150);
  final Paint greenBackground = Paint()
    ..color = const Color.fromARGB(255, 80, 255, 5).withAlpha(150);
  Paint background = Paint()
    ..color = const Color.fromARGB(255, 80, 255, 5).withAlpha(150);
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
  bool onCooldown = false;
  late Timer cooldown;
  late Type abilityType;
  late JoystickComponent joystick;
  AbilityButton({
    required EdgeInsets margin,
    required this.abilityType,
    required this.joystick,
  }) : super(margin: margin) {
    // explicit cooldown timers
    double cooldownTime;
    switch (abilityType) {
      case Fireball:
        cooldownTime = 1;
        break;
      case Arrow:
        cooldownTime = 1;
        break;
      default:
        cooldownTime = 1;
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
      onCooldown = true;
      cooldown.start();
      switch (abilityType) {
        case Fireball:
          gameRef.add(Fireball(direction: joystick.direction));
          break;
        case Iceball:
          gameRef.add(Iceball(direction: joystick.direction));
          break;
        case Beam:
          gameRef.add(Beam(direction: joystick.direction));
          break;
        case Arrow:
          gameRef.add(Arrow(direction: joystick.direction));
          break;
        case Cluster:
          gameRef.add(Cluster(direction: joystick.direction));
          break;
        case GreenHit:
          gameRef.add(GreenHit(direction: joystick.direction));
          break;
        case Whirlwind:
          gameRef.add(Whirlwind(direction: joystick.direction));
          break;
        case Impact:
          gameRef.add(Impact(direction: joystick.direction));
          break;
        case Sword:
          gameRef.add(Sword(direction: joystick.direction));
          break;
        default:
          print(
            "ABILITY BUTTON SWITCH DEFAULT CASE: ability type not recognized!!!",
          );
          break;
      }
    }
    return true;
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
