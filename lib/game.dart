import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/main.dart';
import 'package:yaniv_calculator/party.dart';
import 'package:yaniv_calculator/file_handler.dart';
import 'package:yaniv_calculator/modal_new_round.dart';

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
  State<Game> createState() => _GameState(selectedParty, playersNames);
}

class _GameState extends State<Game> {
  final Party? selectedParty;
  final List<String> playersNames;

  _GameState(this.selectedParty, this.playersNames);

  DateTime startDate = DateTime.now();
  DateTime actualDate = DateTime.now();
  late Party actualParty;

  Future<void> _initParty() async {
    final file = FileHandler.instance;
    final parties = await file.readParty();

    if (selectedParty != null) {
      setState(() {
        actualParty = selectedParty!;
      });
    }
  }

  Future<void> _addNewRound() async {
    var newScore =
        await Yaniv.showSimpleModalDialog(context, actualParty.players);

    if (newScore != null) {
      setState(() {
        actualParty.rounds.add({'score': newScore});
      });
      FileHandler.instance
          .updateParty(id: actualParty.id, updatedParty: actualParty);
    }
  }

  List<int> _computeScore(int roundToScore) {
    List<int> score =
        List<int>.generate(actualParty.players.length, (index) => 0);
    for (int i = 0; i < roundToScore; i++) {
      actualParty.rounds[i]['score']?.asMap().entries.forEach(
            (value) => {score[value.key] = score[value.key] + value.value},
          );
    }
    return score;
  }

  @override
  void initState() {
    super.initState();
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
                style: TextStyle(color: Color(0xDDFFFFFF)),
              ),
              backgroundColor: const Color.fromARGB(149, 241, 10, 10),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(),
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
                      ...actualParty.players.map((name) => Text(name))
                    ],
                  ),
                  ...actualParty.rounds.asMap().entries.map(
                        (entry) => TableRow(
                          children: [
                            Text((entry.key + 1).toString()),
                            ...?entry.value['score']
                                ?.map((score) => Text(score.toString()))
                          ],
                        ),
                      ),
                  TableRow(
                    children: [
                      const Text('Total'),
                      ..._computeScore(actualParty.rounds.length)
                          .map((score) => Text(score.toString()))
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _addNewRound,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          )
        : const Text('please wait');
  }
}
