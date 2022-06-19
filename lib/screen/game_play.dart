import 'package:Atlas/main.dart';
import 'package:flame/game.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

AtlasGame _atlasGame = AtlasGame();

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: _atlasGame,
    );
  }
}
