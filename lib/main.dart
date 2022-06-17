import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'loaders.dart';
import 'characters/atlas.dart';

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
          overlayBuilderMap: null,
        ),
      ),
    ),
  );
}

class AtlasGame extends FlameGame with HasCollisionDetection, HasDraggables {
  late AtlasCharacter atlas;
  late final JoystickComponent joystick;

  late double mapWidth;
  late double mapHeight;

  // sound
  late String soundTrackName = "ukulele";

  // point system
  int friendNumber = 0;
  int bakedGoodsInventory = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // create tiles/colison
    final homeMap = await TiledComponent.load(
      "map.tmx",
      Vector2.all(16),
    );

    mapWidth = homeMap.tileMap.map.width * 16.0;
    mapHeight = homeMap.tileMap.map.height * 16.0;

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

    // add components to map
    add(homeMap);
    addBakedGoods(homeMap, this);
    addFriends(homeMap, this);
    addObstacles(homeMap, this);
    add(atlas);
    add(joystick);
  }
}
