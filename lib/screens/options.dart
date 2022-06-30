import 'package:Atlas/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class Options extends StatelessWidget {
  final FlameGame? game;
  const Options({Key? key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                "Settings",
                style: TextStyle(
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
                ? SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // resume game
                          if (game!.paused) {
                            game!.resumeEngine();
                          }
                          // exit settings
                          Navigator.of(context).pop();
                        },
                        child: const Text("Resume"),
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              width: 85,
              child: ElevatedButton(
                onPressed: () {
                  //navigation to options button
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainMenu(),
                    ),
                    (route) => route.isFirst,
                  );
                },
                child: const Text("Quit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
