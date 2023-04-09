import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/file_handler.dart';
import 'package:yaniv_calculator/game.dart';
import 'package:yaniv_calculator/party.dart';
import 'package:yaniv_calculator/set_player.dart';

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
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final file = FileHandler.instance;

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
                  builder: (context) => const SetPlayer(),
                ),
              ),
              child: const Text('New Game'),
            ),
            FutureBuilder<List<Party>>(
              future: file.readParty(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Party>> snapshot) {
                if (snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }

                return CupertinoButton(
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
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
