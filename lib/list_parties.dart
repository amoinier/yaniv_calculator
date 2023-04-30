import 'package:flutter/material.dart';
import 'package:yaniv_calculator/game.dart';
import 'package:yaniv_calculator/main.dart';
import 'package:yaniv_calculator/party.dart';
import 'package:yaniv_calculator/player.dart';

class ListParties extends StatefulWidget {
  const ListParties({super.key});

  @override
  State<ListParties> createState() => _ListPartiesState();
}

class _ListPartiesState extends State<ListParties> {
  late List<Party> parties = [];

  _ListPartiesState();

  _setPartiesFromStorage() async {
    var partiesFromStorage = await Party.read();

    setState(() {
      partiesFromStorage.sort(
        (a, b) => DateTime.parse(a.creationDate)
            .compareTo(DateTime.parse(b.creationDate)),
      );

      parties = partiesFromStorage;
    });
  }

  _removeParty(Party partyToRemove) {
    setState(
      () {
        parties =
            List.from(parties.where((party) => party.id != partyToRemove.id));
      },
    );
    partyToRemove.delete();
  }

  @override
  void initState() {
    super.initState();
    _setPartiesFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yaniv Calculator',
          style: TextStyle(color: Color(0xDDFFFFFF)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MenuScreen(),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: parties.length,
        itemBuilder: (context, index) {
          final party = parties[index];
          return Dismissible(
            key: Key(party.id),
            onDismissed: (DismissDirection direction) {
              _removeParty(party);
            },
            background: Container(color: Colors.red),
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 227, 227, 227)),
                ),
              ),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Game(
                      selectedParty: party,
                    ),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(party.creationDate),
                      const Text(' - '),
                      Text(
                        party.players
                            .map(
                              (playerId) =>
                                  Player.findPlayer(playerId)?.name ?? '',
                            )
                            .join(', '),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
