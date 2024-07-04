import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/main.dart';
import 'package:yaniv_calculator/party.dart';
import 'package:yaniv_calculator/modal_new_round.dart';
import 'package:yaniv_calculator/player.dart';

const uuid = Uuid();

class Game extends StatefulWidget {
  const Game({
    super.key,
    required this.selectedParty,
    this.playersNames = const [],
  });

  final Party? selectedParty;
  final List<String> playersNames;

  @override
  State<Game> createState() {
    return _GameState();
  }
}

class _GameState extends State<Game> {
  late Party? selectedParty;
  late List<String> playersNames;

  _GameState();

  DateTime startDate = DateTime.now();
  DateTime actualDate = DateTime.now();
  late Party actualParty;

  Future<void> _initParty() async {
    if (selectedParty != null) {
      setState(() {
        actualParty = selectedParty!;
      });
    }
  }

  Future<void> _triggerAddNewRound() async {
    var newRound =
        await Yaniv.showSimpleModalDialog(context, actualParty.players);

    if (newRound != null) {
      setState(() {
        actualParty.addNewRound(newRound.score, newRound.asafPlayerId);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedParty = widget.selectedParty;
    playersNames = widget.playersNames;
    actualParty = Party(
      id: uuid.v4(),
      players: playersNames,
      rounds: [],
      creationDate: DateTime.now().toString(),
    );
    _initParty();
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(const Duration(seconds: 0), (timer) {
    //   setState(() {
    //     actualDate = DateTime.now();
    //   });
    // });

    return actualParty.id.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                'Yaniv Calculator',
                style: TextStyle(color: Color.fromARGB(255, 251, 244, 241)),
              ),
              backgroundColor: const Color.fromARGB(254, 10, 10, 10),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 251, 244, 241),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      const Text('Tour'),
                      ...actualParty.players.map(
                        (playerId) => Text(
                          Player.findPlayer(playerId)?.name ?? '',
                        ),
                      ),
                    ],
                  ),
                  ...actualParty.rounds.asMap().entries.map(
                        (entry) => TableRow(
                          children: [
                            Text((entry.key + 1).toString()),
                            ...entry.value.score
                                .map((score) => Text(score.toString())),
                          ],
                        ),
                      ),
                  TableRow(
                    children: [
                      const Text('Total'),
                      ...actualParty
                          .computeScoreFromRound(actualParty.rounds.length)
                          .map((score) => Text(score.toString())),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _triggerAddNewRound,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          )
        : const Text('please wait');
  }
}
