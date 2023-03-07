import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'hud.dart';
import 'loaders.dart';
import 'screens/menu.dart';
import 'screens/options.dart';
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
      theme: ThemeData(fontFamily: 'BABA'),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const MainMenu(),
    ),
  );
}

class AtlasGame extends FlameGame
    with
        KeyboardEvents,
        HasCollisionDetection,
        HasDraggables,
        HasTappables,
        WidgetsBindingObserver {
  // game set up
  late Hud hud;
  late AtlasCharacter atlas;
  BuildContext context;

  // arena
  late Timer waveClock;
  late double mapWidth;
  late double mapHeight;

  // sound
  late String soundTrackName = "ukulele";

  // door
  double health = 100;
  late Vector2 doorPosition;

  // wave mechanics
  bool waveInterim = true; // is in interim
  bool waveInterimHook = false;
  double currentInterimTime = 0;
  final double waveInterimTime = 10; // time (s) for interim between waves
  final double spawnerTime = 1;

  int currentWave = 0; // current wave number
  final int minWaveSpawnSkelet = 5; // min wave before skelet spawn
  final int minWaveSpawnNecro = 10; // min wave before encro spawn

  int enemiesCount = 0; // current enemies count
  final int waveEnemiesCountMulti = 10; // enemies multiplier for waves

  AtlasGame(this.context, CharName charName) {
    // debugMode = true;

    // tell if game (while running) has been minimized or closed
    WidgetsBinding.instance.addObserver(this);

    // head up display
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

  void scaleGame() {
    double zoomLevelX = 1;
    double zoomLevelY = 1;

    if (canvasSize.x > mapWidth) {
      zoomLevelX = canvasSize.x / mapWidth;
    }
    if (canvasSize.y > mapHeight) {
      zoomLevelY = canvasSize.y / mapHeight;
    }

    if (zoomLevelX > 1 || zoomLevelY > 1) {
      double zoomLevel = min(zoomLevelX, zoomLevelY);
      camera.zoom = zoomLevel;
    }
  }

  void waveMechanics() {
    if (waveInterim) {
      interim();
    } else {
      spawner();
    }
  }

  void spawner() {
    print("enemiesCount: $enemiesCount");

    final int enemiesLimit = currentWave * waveEnemiesCountMulti;
    if (enemiesCount > enemiesLimit) {
      print("ENEMY LIMIT REACHED, BEGIN INTERIM");
      enemiesCount = 0;
      currentInterimTime = 0;
      waveInterim = true;
    }

    if (currentWave >= minWaveSpawnSkelet) {
      add(Skelet());
      enemiesCount++;
    }
    if (currentWave >= minWaveSpawnNecro) {
      add(Necro());
      enemiesCount++;
    }
    add(Goblin());
    enemiesCount++;
  }

  void interim() {
    if (currentInterimTime >= waveInterimTime) {
      print("END INTERIM");
      currentWave++;
      waveInterim = false;
      hud.waveTextComponent.text = "Wave: $currentWave";
    }

    currentInterimTime++;
    print(currentInterimTime);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // create tiles/collision
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

    waveClock = Timer(
      spawnerTime,
      repeat: true,
      onTick: () {
        waveMechanics();
      },
    );
    waveClock.start();

    add(homeMap);
    addObstacles(homeMap, this);
    add(atlas);
    add(hud);
  }

  @override
  void update(double dt) {
    super.update(dt);
    waveClock.update(dt);
    scaleGame();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state != AppLifecycleState.resumed && !paused) {
      pauseEngine();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Options(game: this),
        ),
      );
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    return atlas.moveWithWASD(keysPressed);
  }
}
