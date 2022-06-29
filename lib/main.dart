import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'hud.dart';
import 'loaders.dart';
import 'screens/menu.dart';
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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const MainMenu(),
    ),
  );
}

class AtlasGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  // game set up
  late Hud hud;
  BuildContext context;
  late AtlasCharacter atlas;

  // arena
  late Timer clock;
  late double mapWidth;
  late double mapHeight;

  // sound
  late String soundTrackName = "ukulele";

  // door
  int health = 100;
  late Vector2 doorPosition;

  AtlasGame(this.context, CharName charName) {
    hud = Hud(
      game: this,
      priority: 1,
      context: context,
      character: charName,
    );

    // create selected atlas character
    switch (charName) {
      case CharName.mage:
        atlas = Mage(
          position: Vector2(529, 128),
          joystick: hud.joystick,
        );
        break;
      case CharName.archer:
        atlas = Archer(
          position: Vector2(529, 128),
          joystick: hud.joystick,
        );
        break;
      case CharName.knight:
        atlas = Knight(
          position: Vector2(529, 128),
          joystick: hud.joystick,
        );
        break;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // create tiles/colison
    final homeMap = await TiledComponent.load(
      "arena.tmx",
      Vector2.all(10),
    );

    // map size
    mapWidth = homeMap.tileMap.map.width * 10.0;
    mapHeight = homeMap.tileMap.map.height * 10.0;

    // door position
    doorPosition = Vector2(mapWidth / 2, 0);

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
        add(Skelet());
        add(Necro());
        add(Goblin());
      },
    );
    clock.start();

    add(homeMap);
    addObstacles(homeMap, this);
    add(atlas);
    add(hud);
  }

  @override
  void update(double dt) {
    super.update(dt);
    clock.update(dt);
  }
}
