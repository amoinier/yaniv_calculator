import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yaniv_calculator/game.dart';

class SetPlayer extends StatefulWidget {
  const SetPlayer({Key? key}) : super(key: key);

  @override
  State<SetPlayer> createState() => _SetPlayerState();
}

class _SetPlayerState extends State<SetPlayer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode inputFocus = FocusNode();
  final List<String> _players = [];
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
    _controller.clear();
    inputFocus.requestFocus();
    setState(() {
      _players.add(_newPlayer);
      _newPlayer = '';
    });
  }

  void _onPressEnter(String value) {
    _onSubmitPlayerName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yaniv Calculator',
          style: TextStyle(color: Color(0xDDFFFFFF)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return Dismissible(
                  key: Key(player),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.delete, color: Colors.white),
                        )
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
                          Text(player),
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
                    controller: _controller,
                    focusNode: inputFocus,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new player name',
                    ),
                    onChanged: _onChangedPlayerName,
                    onSubmitted: _onPressEnter,
                  ),
                ),
                const SizedBox.shrink(),
                TextButton(
                  onPressed: _onSubmitPlayerName,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Game(
                selectedParty: null,
                playersNames: _players,
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
