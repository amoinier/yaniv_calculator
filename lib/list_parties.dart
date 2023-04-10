import 'package:flutter/material.dart';
import 'package:yaniv_calculator/file_handler.dart';
import 'package:yaniv_calculator/game.dart';
import 'package:yaniv_calculator/party.dart';

class ListParties extends StatelessWidget {
  final List<Party> parties;

  const ListParties({super.key, required this.parties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yaniv Calculator',
          style: TextStyle(color: Color(0xDDFFFFFF)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ...parties.asMap().entries.map(
                (entry) => Card(
                  child: InkWell(
                    onLongPress: () {
                      FileHandler.instance.deleteParty(entry.value);
                    },
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Game(
                          selectedParty: entry.value,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(entry.value.creationDate),
                          const Text(' - '),
                          Text(entry.value.players.join(', '))
                        ],
                      ),
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
