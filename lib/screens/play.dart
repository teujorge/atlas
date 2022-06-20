import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AtlasGame _atlasGame = AtlasGame(context);

    return GameWidget(game: _atlasGame);
  }
}
