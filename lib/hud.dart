import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:async';
import 'dart:typed_data';
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

    // greater than zero health/energy
    final double atlasHealth = game.atlas.health > 0 ? game.atlas.health : 0;
    final double atlasEnergy = game.atlas.energy > 0 ? game.atlas.energy : 0;

    // atlas health bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, atlasHealth * 2, 50),
        Radius.circular(atlasHealth),
      ),
      Paint()..color = const Color.fromARGB(255, 255, 10, 10),
    );
    // atlas energy bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 50, atlasEnergy * 2, 50),
        Radius.circular(atlasEnergy),
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

    // ability image paths
    List<String> imagePaths = [];

    // change ability button colors
    if (game.atlas is Mage) {
      energyColor = Colors.purple;
      imagePaths.add(Mage.abilityImagePaths[0]);
      imagePaths.add(Mage.abilityImagePaths[1]);
      imagePaths.add(Mage.abilityImagePaths[2]);
    } else if (game.atlas is Knight) {
      energyColor = Colors.orange;
      imagePaths.add(Knight.abilityImagePaths[0]);
      imagePaths.add(Knight.abilityImagePaths[1]);
      imagePaths.add(Knight.abilityImagePaths[2]);
    } else if (game.atlas is Archer) {
      energyColor = Colors.yellow;
      imagePaths.add(Archer.abilityImagePaths[0]);
      imagePaths.add(Archer.abilityImagePaths[1]);
      imagePaths.add(Archer.abilityImagePaths[2]);
    }

    // add abilities buttons
    add(
      // ability 1
      AbilityButton(
        atlasGame: game,
        abilityWhich: 1,
        margin: abilityMargin1,
        image: imagePaths[0],
      ),
    );
    add(
      // ability 2
      AbilityButton(
        atlasGame: game,
        abilityWhich: 2,
        margin: abilityMargin2,
        image: imagePaths[1],
      ),
    );
    add(
      // ability 3
      AbilityButton(
        atlasGame: game,
        abilityWhich: 3,
        margin: abilityMargin3,
        image: imagePaths[2],
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
  String? imagePath;

  HudButton({
    required EdgeInsets margin,
    this.imagePath,
  }) : super(
          margin: margin,
          size: Vector2.all(50),
        );

  Future<ui.Image> loadImage(Uint8List img) {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<ui.Image> initImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return loadImage(Uint8List.view(data.buffer));
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (imagePath != null) {
      image = await initImage(imagePath!);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // background
    canvas.drawRect(size.toRect(), background);
    // image
    if (image != null) {
      canvas.drawImage(image!, const Offset(0, 0), background);
    }
    // outline
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
  final TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);

  PauseButton({required EdgeInsets margin, required this.context, image})
      : super(margin: margin, imagePath: image) {
    IconData icon = Icons.settings_rounded;
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(fontSize: 50.0, fontFamily: icon.fontFamily),
    );
    textPainter.layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPainter.paint(canvas, Offset.zero);
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
  AtlasGame atlasGame;
  late Timer cooldown;
  bool onCooldown = false;
  late Function abilityFn;
  final int abilityWhich;
  late final double abilityEnergy;

  AbilityButton({
    image,
    required this.atlasGame,
    required EdgeInsets margin,
    required this.abilityWhich,
  }) : super(margin: margin, imagePath: image) {
    double cooldownTime = 2;
    switch (abilityWhich) {
      case 1:
        cooldownTime = atlasGame.atlas.abilityCooldown1;
        abilityEnergy = atlasGame.atlas.abilityEnergy1;
        abilityFn = atlasGame.atlas.ability1;
        break;
      case 2:
        cooldownTime = atlasGame.atlas.abilityCooldown2;
        abilityEnergy = atlasGame.atlas.abilityEnergy2;
        abilityFn = atlasGame.atlas.ability2;
        break;
      case 3:
        cooldownTime = atlasGame.atlas.abilityCooldown3;
        abilityEnergy = atlasGame.atlas.abilityEnergy3;
        abilityFn = atlasGame.atlas.ability3;
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
    if (onCooldown) {
      canvas.drawRect(
        Vector2(size.x - cooldown.progress * size.x, 5).toRect(),
        Paint()..color = const Color.fromARGB(255, 255, 255, 255),
      );
    }
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
    if (abilityEnergy > atlasGame.atlas.energy) {
      notEnoughEnergy = true;
    }

    if (onCooldown || notEnoughEnergy) {
      background = disableBackground;
    } else {
      background = ableBackground;
    }
  }
}
