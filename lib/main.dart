import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/list_parties.dart';
import 'package:yaniv_calculator/new_game.dart';
import 'package:yaniv_calculator/player.dart';
import 'package:yaniv_calculator/rules.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 251, 244, 241),
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  _MenuScreenState();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Rules(),
    NewGame(),
    ListParties(),
  ];

  @override
  Widget build(BuildContext context) {
    Player.readAsync();

    return Container(
      color: const Color.fromARGB(255, 10, 10, 10),
      child: SafeArea(
        child: Scaffold(
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(48.0),
              topRight: Radius.circular(48.0),
            ),
            child: BottomNavigationBar(
              onTap: _onItemTapped,
              backgroundColor: const Color.fromARGB(255, 10, 10, 10),
              elevation: 0,
              iconSize: 32,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedItemColor: const Color.fromARGB(255, 251, 244, 241),
              unselectedItemColor: const Color.fromARGB(155, 251, 244, 241),
              currentIndex: _selectedIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.gavel,
                  ),
                  label: "Game's Rules",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                  ),
                  label: 'New game',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list_alt,
                  ),
                  label: 'Reopen older game',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
