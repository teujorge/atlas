import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:george/dialog/dialog_box.dart';

import 'characters/george.dart';
import 'loaders.dart';

//  Load the game widgets
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: GeorgeGame(),
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

class GeorgeGame extends FlameGame with TapDetector, HasCollisionDetection {
  late GeorgeComponent george;

  late double mapWidth;
  late double mapHeight;

  // sound
  late String soundTrackName = "ukulele";

  // point system
  int friendNumber = 0;
  int bakedGoodsInventory = 0;

  // sfx
  late AudioPool yummy;
  late AudioPool applause;

  // late DialogBox dialogBox;

  bool showDialog = true;

  String dialogMessage = "Hi. I am George. I have just "
      "moved to Happy Bay VIllage. "
      " I want to make friends.";

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

    //dialog box
    // dialogBox = DialogBox(
    //     text: "Hi. I am George. I have just "
    //         "moved to Happy Bay VIllage. "
    //         " I want to make friends.",
    //     game: this);
    // add(dialogBox);

    // sounds
    yummy = await AudioPool.create("yummy.mp3", maxPlayers: 1);
    applause = await AudioPool.create("applause.mp3", maxPlayers: 1);

    // THE MUSIC DOESN'T WORK ON WINDOWS
    // add music
    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.load("assets_audio_music.mp3");
    overlays.add("ButtonController");

    // add george to map
    george = GeorgeComponent(
      position: Vector2(529, 128),
    );
    add(george);

    // flame game camera follow character
    camera.followComponent(
      george,
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
    switch (george.direction) {
      case Direction.idle:
        george.direction = Direction.down;
        break;

      case Direction.down:
        george.direction = Direction.left;
        break;

      case Direction.left:
        george.direction = Direction.up;
        break;

      case Direction.up:
        george.direction = Direction.right;
        break;

      case Direction.right:
        george.direction = Direction.idle;
        break;
    }

    print("change animation ");
  }
}
