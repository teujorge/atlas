import 'package:Atlas/characters/enemy.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'loaders.dart';
import 'hud/hud.dart';
import 'characters/atlas.dart';
import '../characters/enemy.dart';

//  Load the game widgets
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  Flame.device.fullScreen();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: AtlasGame(),
        ),
      ),
    ),
  );
}

class AtlasGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late AtlasCharacter atlas;
  late final JoystickComponent joystick;

  late Timer clock;

  late double mapWidth;
  late double mapHeight;

  // sound
  late String soundTrackName = "ukulele";

  // point system
  int kills = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // create tiles/colison
    final homeMap = await TiledComponent.load(
      "arena.tmx",
      Vector2.all(10),
    );

    mapWidth = homeMap.tileMap.map.width * 10.0;
    mapHeight = homeMap.tileMap.map.height * 10.0;

    // joystick
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 75, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    // create atlas character
    atlas = AtlasCharacter(
      position: Vector2(529, 128),
      joystick: joystick,
    );

    // flame game camera follow character
    camera.followComponent(
      atlas,
      worldBounds: Rect.fromLTRB(
        0,
        0,
        mapWidth,
        mapHeight,
      ),
    );

    clock = Timer(
      2,
      repeat: true,
      onTick: () {
        add(EnemyCharacter());
      },
    );
    clock.start();

    add(homeMap);

    // addBakedGoods(homeMap, this);
    // addFriends(homeMap, this);
    // addObstacles(homeMap, this);

    add(atlas);
    add(joystick);
    add(Hud(priority: 1));
  }

  @override
  void onTap() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    clock.update(dt);
  }
}
