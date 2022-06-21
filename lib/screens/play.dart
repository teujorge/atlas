import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../loaders.dart';

class GamePlay extends StatelessWidget {
  late final CharName character;
  GamePlay({Key? key, required int character}) : super(key: key) {
    switch (character) {
      case 0:
        this.character = CharName.mage;
        break;
      case 1:
        this.character = CharName.archer;
        break;
      case 2:
        this.character = CharName.knight;
        break;
      default:
        this.character = CharName.mage;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    AtlasGame _atlasGame = AtlasGame(context, character);
    return GameWidget(game: _atlasGame);
  }
}
