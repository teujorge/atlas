import 'package:flutter/material.dart';

import '../config.dart';
import 'character.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background_castle.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: BabaText(
                  "Atlas Arena",
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CharacterSelection(),
                    ),
                  );
                },
                child: BabaText("Play"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
