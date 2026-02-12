// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _increaseNumber();
}

class _increaseNumber extends State<MyHomePage> {
  int _counterRed = 0;
  int _counterBlue = 0;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: _incrementCounterRed, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red ),
            child: Text( 'Tap: $_counterRed'),
          ),
          ElevatedButton(
            onPressed: _incrementCounterBlue,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Tap: $_counterBlue'),

          ),
        ],
      ),
    );
  }
}
