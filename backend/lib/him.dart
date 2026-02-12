import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

enum CardType { red, blue }

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ColorTap(type: CardType.red),
        ColorTap(type: CardType.blue),
        ColorTap(type: CardType.blue),
      ],
    );
  }
}

class ColorTap extends StatefulWidget {
  final CardType type;

  const ColorTap({super.key, required this.type});

  @override
  ColorTapState createState() => ColorTapState();
}

class ColorTapState extends State<ColorTap> {
  int _counterRed = 0;
  int _counterBlue = 0;

  Color get backgroundColor =>
      widget.type == CardType.red ? Colors.red : Colors.blue;

  void _incrementCounterRed() {
    setState(() {
      _counterRed++;
    });
  }

  void _incrementCounterBlue() {
    setState(() {
      _counterBlue++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 100,
        child: Column(
          children: [
            Text(
              'Taps: $_counterBlue',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              'Taps: $_counterRed',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
