import 'package:Atlas/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../config.dart';

class Options extends StatelessWidget {
  final FlameGame? game;
  const Options({Key? key, this.game}) : super(key: key);

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
                "Settings",
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
            game != null
                ? Button(
                    onPressed: () {
                      // resume game
                      if (game!.paused) {
                        game!.resumeEngine();
                      }
                      // exit settings
                      Navigator.of(context).pop();
                    },
                    child: BabaText("Resume"),
                  )
                : Button(
                    onPressed: () {
                      // exit settings
                      Navigator.of(context).pop();
                    },
                    child: BabaText("Back"),
                  ),
            Button(
              onPressed: () {
                if (game != null) {
                  // warn user of quitting game
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: BabaText('Quitting Game?'),
                      content: BabaText('Your progress will be lost!'),
                      actions: <Widget>[
                        Button(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: BabaText('Cancel'),
                        ),
                        Button(
                          onPressed: () => {
                            Navigator.pop(context, 'OK'),
                            goToHomePage(context),
                          },
                          child: BabaText('OK'),
                        ),
                      ],
                    ),
                  );
                }

                // go to home
                else {
                  goToHomePage(context);
                }
              },
              child: BabaText("Quit"),
            ),
          ],
        ),
      ),
    );
  }
}
