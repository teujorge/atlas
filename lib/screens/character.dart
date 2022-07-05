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
      BabaText("Mage Abilities"),
      Row(
        children: [
          BabaText("Fireball"),
          Image.asset(
            'assets/images/abilities/fireball.gif',
          ),
        ],
      ),
      Row(
        children: [
          BabaText("Iceball"),
          Image.asset(
            'assets/images/abilities/iceball.gif',
          ),
        ],
      ),
      Row(
        children: [
          BabaText("Arcane Beam"),
          Image.asset(
            'assets/images/abilities/beam.gif',
          ),
        ],
      ),
    ],
    // elf abilities
    [
      BabaText("Elf Abilities"),
      Row(
        children: [
          BabaText("Arrow"),
          Image.asset(
            'assets/images/abilities/arrow.gif',
          ),
        ],
      ),
      Row(
        children: [
          BabaText("Cluster"),
          Image.asset(
            'assets/images/abilities/cluster.gif',
          ),
        ],
      ),
      Row(
        children: [
          BabaText("Green Hit"),
          Image.asset(
            'assets/images/abilities/green_hit.gif',
          ),
        ],
      ),
    ],
    // knight abilities
    [
      BabaText("Knight Abilities"),
      Row(
        children: [
          BabaText("Sword"),
          Image.asset(
            'assets/images/abilities/sword.gif',
          ),
        ],
      ),
      Row(
        children: [
          BabaText("Impact"),
          Image.asset(
            'assets/images/abilities/impact.gif',
          ),
        ],
      ),
      Row(
        children: [
          BabaText("Whirlwind"),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: BabaText(
              "Character Selection",
              style: const TextStyle(
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
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 27, 27, 27)),
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
              child: BabaText("Play"),
            ),
            Button(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Options(),
                  ),
                );
              },
              child: BabaText("Options"),
            ),
          ]),
        ]),
      ),
    );
  }
}
