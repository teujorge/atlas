import 'package:Atlas/loaders.dart';
import 'package:Atlas/screens/menu.dart';
import 'package:Atlas/screens/play.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class GameOver extends StatelessWidget {
  final CharName character;
  const GameOver({Key? key, required this.character}) : super(key: key);

  void restartGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamePlay(
          character: character,
        ),
      ),
    );
  }

  void goToHomePage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainMenu(),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: BabaText(
                "Game Over",
                style: const TextStyle(
                  fontSize: 50.0,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Color.fromARGB(199, 255, 255, 255),
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Button(
              onPressed: () => restartGame(context),
              child: BabaText("Restart"),
            ),
            Button(
              onPressed: () => goToHomePage(context),
              child: BabaText("Quit"),
            ),
          ],
        ),
      ),
    );
  }
}
