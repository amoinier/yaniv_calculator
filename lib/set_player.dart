import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaniv_calculator/game.dart';

class SetPlayer extends StatefulWidget {
  const SetPlayer({super.key});

  @override
  State<SetPlayer> createState() => _SetPlayerState();
}

class _SetPlayerState extends State<SetPlayer> {
  List<String> players = [];
  String newPlayer = '';

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ...players.asMap().entries.map(
                  (entry) => Text(entry.value),
                ),
            Container(
              constraints: const BoxConstraints(maxHeight: 350, maxWidth: 350),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a new player name',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          return;
                        }

                        newPlayer = value;
                      },
                    ),
                  ),
                  CupertinoButton(
                    color: Colors.black,
                    onPressed: () {
                      if (newPlayer.isEmpty) {
                        return;
                      }

                      controller.clear();
                      setState(
                        () {
                          players.add(newPlayer);
                          newPlayer = '';
                        },
                      );
                    },
                    child: const Text('test'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Game(
                title: 'Yaniv Calculator',
                newGame: true,
                playersNames: players,
              ),
            ),
          ),
          backgroundColor: Colors.pink,
          child: const Text('Start'),
        )
      ],
    );
  }
}
