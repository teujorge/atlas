import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class GamePlay extends StatelessWidget {
  late String character;
  GamePlay({Key? key, required int character}) : super(key: key) {
    switch (character) {
      case 0:
        this.character = "mage";
        break;

      case 1:
        this.character = "elf";
        break;
      case 2:
        this.character = "knight";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    AtlasGame _atlasGame = AtlasGame(context, character);

    return GameWidget(game: _atlasGame);
  }
}
