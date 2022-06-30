import 'package:Atlas/config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../screens/options.dart';
import 'play.dart';

class CharacterSelection extends StatefulWidget {
  CharacterSelection({Key? key}) : super(key: key);

  final List<String> characters = ["mage", "archer", "knight"];
  final List<List<Widget>> abilityInfo = [
    // mage abilities
    [
      const Text("Mage Abilities"),
      Row(
        children: [
          const Text("Fireball"),
          Image.asset(
            'assets/images/abilities/fireball.gif',
          ),
        ],
      ),
      Row(
        children: [
          const Text("Iceball"),
          Image.asset(
            'assets/images/abilities/iceball.gif',
          ),
        ],
      ),
      Row(
        children: [
          const Text("Arcane Beam"),
          Image.asset(
            'assets/images/abilities/beam.gif',
          ),
        ],
      ),
    ],
    // elf abilities
    [
      const Text("Elf Abilities"),
      Row(
        children: [
          const Text("Arrow"),
          Image.asset(
            'assets/images/abilities/arrow.gif',
          ),
        ],
      ),
      Row(
        children: [
          const Text("Cluster"),
          Image.asset(
            'assets/images/abilities/cluster.gif',
          ),
        ],
      ),
      Row(
        children: [
          const Text("Green Hit"),
          Image.asset(
            'assets/images/abilities/green_hit.gif',
          ),
        ],
      ),
    ],
    // knight abilities
    [
      const Text("Knight Abilities"),
      Row(
        children: [
          const Text("Sword"),
          Image.asset(
            'assets/images/abilities/sword.gif',
          ),
        ],
      ),
      Row(
        children: [
          const Text("Impact"),
          Image.asset(
            'assets/images/abilities/impact.gif',
          ),
        ],
      ),
      Row(
        children: [
          const Text("Whirlwind"),
          Image.asset(
            'assets/images/abilities/whirlwind.gif',
          ),
        ],
      ),
    ],
  ];

  @override
  State<CharacterSelection> createState() => CharacterSelectionState();
}

class CharacterSelectionState extends State<CharacterSelection> {
  int selectedCharacter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Character Selection",
              style: TextStyle(
                fontSize: 30.0,
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
          CarouselSlider.builder(
            itemCount: 3,
            options: CarouselOptions(
              height: 200,
              aspectRatio: 2,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                selectedCharacter = index;
              },
            ),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(color: Colors.amber),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/images/atlas/${widget.characters[index]}_idle.gif',
                      scale: 1 / 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: widget.abilityInfo[index],
                    ),
                  ],
                ),
              );
            },
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Button(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GamePlay(
                      character: selectedCharacter,
                    ),
                  ),
                );
              },
              child: const Text("Play"),
            ),
            Button(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Options(),
                  ),
                );
              },
              child: const Text("Options"),
            ),
          ]),
        ]),
      ),
    );
  }
}
