import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yaniv_calculator/player.dart';

import 'game.dart';

class NewGame extends StatefulWidget {
  const NewGame({super.key});

  @override
  State<NewGame> createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode inputFocus = FocusNode();
  final List<Player> _players = [];
  String _newPlayer = '';

  void _onChangedPlayerName(String value) {
    if (value.isEmpty) {
      return;
    }
    _newPlayer = value;
  }

  void _onSubmitPlayerName() {
    if (_newPlayer.isEmpty) {
      return;
    }
    final newPlayer = Player(name: _newPlayer);
    _controller.clear();
    inputFocus.requestFocus();
    setState(() {
      _players.add(newPlayer);
      _newPlayer = '';
    });
  }

  void _onPressEnter(String value) {
    _onSubmitPlayerName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return Dismissible(
                  key: Key(player.id),
                  onUpdate: (DismissUpdateDetails direction) {
                    // print(direction.direction);
                    // print(direction.previousReached);
                    // print(direction.progress);
                    // print(direction.reached);
                    if (direction.progress >= 1) {
                      Timer(
                        const Duration(milliseconds: 500),
                        () => setState(() {
                          _players.removeWhere(
                            (playerFromList) => playerFromList == player,
                          );
                        }),
                      );
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 251, 244, 241),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 227, 227, 227),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(player.name),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 350, maxWidth: 350),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      decorationColor: Color.fromARGB(255, 10, 10, 10),
                    ),
                    controller: _controller,
                    focusNode: inputFocus,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new player name',
                      focusedBorder: OutlineInputBorder(),
                    ),
                    onChanged: _onChangedPlayerName,
                    onSubmitted: _onPressEnter,
                  ),
                ),
                const SizedBox.shrink(),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 10, 10, 10),
                  ),
                  onPressed: _onSubmitPlayerName,
                  child: const Text('Add player'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 32,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemCount: Player.read()
                  .where((element) => !_players.contains(element))
                  .length,
              padding: const EdgeInsets.only(left: 16, right: 16),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 10, 10, 10),
                    ),
                    foregroundColor: const Color.fromARGB(255, 10, 10, 10),
                  ),
                  child: Text(
                    Player.read()
                        .where((element) => !_players.contains(element))
                        .toList()[index]
                        .name,
                  ),
                  onPressed: () {
                    setState(() {
                      _players.add(
                        Player.read()
                            .where(
                              (element) => !_players.contains(element),
                            )
                            .toList()[index],
                      );
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          heroTag: 'test',
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: _players.length > 1
              ? () {
                  for (var player in _players
                      .where((element) => !Player.read().contains(element))) {
                    player.write();
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Game(
                        selectedParty: null,
                        playersNames:
                            _players.map((player) => player.id).toList(),
                      ),
                    ),
                  );
                }
              : null,
          backgroundColor: _players.length > 1
              ? const Color.fromARGB(255, 10, 10, 10)
              : const Color.fromARGB(150, 10, 10, 10),
          child: const Text('Start'),
        ),
      ],
    );
  }
}
