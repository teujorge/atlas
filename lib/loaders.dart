import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';
import 'collectables/baked_good.dart';
import 'characters/friends.dart';
import 'characters/obstacle_component.dart';
import 'main.dart';

void addBakedGoods(TiledComponent homeMap, GeorgeGame game) async {
  final bakedGoodsGroup = homeMap.tileMap.getLayer<ObjectGroup>("BakedGoods");

  for (var bakedGood in bakedGoodsGroup!.objects) {
    String? bakedGoodFile;
    switch (bakedGood.type) {
      case 'ApplePie':
        bakedGoodFile = "apple_pie.png";
        break;
      case 'Cookie':
        bakedGoodFile = "cookie.png";
        break;
      case 'CheeseCake':
        bakedGoodFile = "cheesecake.png";
        break;
      case 'ChocoCake':
        bakedGoodFile = "choco_cake.png";
        break;
    }

    if (bakedGoodFile != null) {
      game.add(
        BakedGoodComponent()
          ..position = Vector2(bakedGood.x, bakedGood.y)
          ..width = bakedGood.width
          ..height = bakedGood.height
          ..sprite = await game.loadSprite(bakedGoodFile),
      );
    }
  }
}

void addFriends(TiledComponent homeMap, GeorgeGame game) {
  final friendGroup = homeMap.tileMap.getLayer<ObjectGroup>("Friends");
  for (var friendBox in friendGroup!.objects) {
    game.add(
      FriendsComponent()
        ..position = Vector2(friendBox.x, friendBox.y)
        ..width = friendBox.width
        ..height = friendBox.height,
    );
  }
}

void addObstacles(TiledComponent homeMap, GeorgeGame game) {
  final obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>("Obstacles");
  for (var obstacleBox in obstacleGroup!.objects) {
    game.add(
      ObstacleComponent()
        ..position = Vector2(obstacleBox.x, obstacleBox.y)
        ..width = obstacleBox.width
        ..height = obstacleBox.height,
    );
  }
}
