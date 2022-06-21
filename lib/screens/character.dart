import 'package:Atlas/screens/options.dart';
import 'package:flutter/material.dart';
import 'play.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CharacterSelection extends StatelessWidget {
  const CharacterSelection({Key? key}) : super(key: key);

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
                "Character Selection",
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
            CarouselSlider(
              options: CarouselOptions(height: 200.0, enlargeCenterPage: true),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.amber),
                        child: Text(
                          'text $i',
                          style: TextStyle(fontSize: 16.0),
                        ));
                  },
                );
              }).toList(),
            ),
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GamePlay(),
                      ),
                    );
                  },
                  child: const Text("Play"),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Options(),
                  ),
                );
              },
              child: const Text("Options"),
            ),
          ],
        ),
      ),
    );
  }
}
