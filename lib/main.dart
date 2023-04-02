import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/party.dart';
import 'fileHandler.dart';
import 'modalNewRound.dart';

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
      home: const MyHomePage(title: 'Yaniv Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime startDate = DateTime.now();
  DateTime actualDate = DateTime.now();
  Party actualParty = Party(
    id: uuid.v4(),
    players: [],
    rounds: [],
  );

  Future<void> _initParty() async {
    var file = FileHandler.instance;
    var parties = await file.readParty();

    if (parties.isNotEmpty) {
      setState(() {
        actualParty = parties[0];
      });
    }
  }

  Future<void> _incrementCounter() async {
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
    _initParty();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 0), (timer) {
      setState(() {
        actualDate = DateTime.now();
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (actualDate.difference(startDate)).toString(),
          style: const TextStyle(color: Color(0xDDFFFFFF)),
        ),
        backgroundColor: const Color.fromARGB(149, 241, 10, 10),
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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
