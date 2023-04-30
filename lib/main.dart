import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/file_handler.dart';
import 'package:yaniv_calculator/list_parties.dart';
import 'package:yaniv_calculator/party.dart';
import 'package:yaniv_calculator/player.dart';
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
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Player.readAsync();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yaniv Calculator',
          style: TextStyle(color: Color(0xDDFFFFFF)),
        ),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetPlayer(),
                    ),
                  ),
                  child: const Text('New Game'),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Party>>(
                  future: Party.readAsync(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<Party>> snapshot,
                  ) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListParties(),
                        ),
                      ),
                      child: const Text('Reopen older game'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => FileHandler.instance.clear(),
                  child: const Text('Clear all data'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
