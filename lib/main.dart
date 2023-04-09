import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/game.dart';

var uuid = const Uuid();

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
      theme: ThemeData(primaryColor: Colors.white),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      // home: const Game(title: 'Yaniv Calculator'),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CupertinoButton(
              color: Colors.black,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Game(
                    title: 'Yaniv Calculator',
                    newGame: true,
                  ),
                ),
              ),
              child: const Text('New Game'),
            ),
            CupertinoButton(
              color: Colors.black,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Game(
                    title: 'Yaniv Calculator',
                    newGame: false,
                  ),
                ),
              ),
              child: const Text('Replay last game'),
            )
          ],
        ),
      ),
    );
  }
}
