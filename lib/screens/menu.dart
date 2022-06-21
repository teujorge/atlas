import 'package:flutter/material.dart';

import 'character.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

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
                "Atlas Arena",
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CharacterSelection(),
                    ),
                  );
                },
                child: const Text("Play"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
