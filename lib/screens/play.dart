import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../loaders.dart';

class GamePlay extends StatelessWidget {
  final CharName character;
  const GamePlay({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AtlasGame atlasGame = AtlasGame(context, character);
    return SafeArea(
      child: GameWidget(game: atlasGame),
    );
  }
}
