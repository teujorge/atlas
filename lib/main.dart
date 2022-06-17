import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:flame/extensions.dart';

import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'characters/atlas.dart';
import 'loaders.dart';

//  Load the game widgets
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

enum Direction {
  up,
  down,
  left,
  right,
  idle,
}

class AtlasGame extends FlameGame with TapDetector, HasCollisionDetection {
  late AtlasCharacter atlas;

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

    // add tiles/colison to map
    final homeMap = await TiledComponent.load(
      "map.tmx",
      Vector2.all(16),
    );
    add(homeMap);
    mapWidth = homeMap.tileMap.map.width * 16.0;
    mapHeight = homeMap.tileMap.map.height * 16.0;

    // include baked goods
    addBakedGoods(homeMap, this);
    // friend group
    addFriends(homeMap, this);
    //obstacles
    addObstacles(homeMap, this);

    // add atlas character to map
    atlas = AtlasCharacter(
      position: Vector2(529, 128),
    );
    add(atlas);

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
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onTapUp(info) {
    // change direction on tap
    switch (atlas.direction) {
      case Direction.idle:
        atlas.direction = Direction.down;
        break;

      case Direction.down:
        atlas.direction = Direction.left;
        break;

      case Direction.left:
        atlas.direction = Direction.up;
        break;

      case Direction.up:
        atlas.direction = Direction.right;
        break;

      case Direction.right:
        atlas.direction = Direction.idle;
        break;
    }

    print("change animation ");
  }
}
