import 'package:flame/game.dart';
import 'package:tiled/tiled.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'main.dart';
import 'characters/obstacle.dart';

enum Dir {
  up,
  down,
  left,
  right,
  idle,
}

// create standard 4 frame animation 32x32
Future<SpriteAnimation> createAnimation(
  FlameGame gameRef,
  String animationFile,
  double animationStep,
) async {
  return await gameRef.loadSpriteAnimation(
    animationFile,
    SpriteAnimationData.sequenced(
      amount: 4,
      textureSize: Vector2.all(32),
      stepTime: animationStep,
    ),
  );
}

void addObstacles(TiledComponent homeMap, AtlasGame game) {
  final obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>("Obstacles");
  for (var obstacleBox in obstacleGroup!.objects) {
    game.add(
      Obstacle()
        ..position = Vector2(obstacleBox.x, obstacleBox.y)
        ..width = obstacleBox.width
        ..height = obstacleBox.height,
    );
  }
}
