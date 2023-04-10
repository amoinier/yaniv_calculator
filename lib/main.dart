import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/file_handler.dart';
import 'package:yaniv_calculator/list_parties.dart';
import 'package:yaniv_calculator/party.dart';
import 'package:yaniv_calculator/set_player.dart';

var uuid = const Uuid();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(primaryColor: Colors.white),
      darkTheme: ThemeData.dark(),
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
      appBar: AppBar(
        title: const Text(
          'Yaniv Calculator',
          style: TextStyle(color: Color(0xDDFFFFFF)),
        ),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<List<Party>>(
                future: file.readParty(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Party>> snapshot,
                ) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return CupertinoButton(
                    color: Colors.black,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListParties(
                          parties: snapshot.data ?? [],
                        ),
                      ),
                    ),
                    child: const Text('Reopen older game'),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
