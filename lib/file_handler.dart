import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaniv_calculator/party.dart';

class FileHandler {
  // Makes this a singleton class, as we want only want a single
  // instance of this object for the whole application
  FileHandler._privateConstructor();
  static final FileHandler instance = FileHandler._privateConstructor();
  static SharedPreferences? _sharedPreference;

  // Get the data file
  Future<SharedPreferences> get file async {
    if (_sharedPreference != null) return _sharedPreference!;

    _sharedPreference = await SharedPreferences.getInstance();
    return _sharedPreference!;
  }

  static final Set<Party> _partySet = {};

  Future<void> writeParty(Party party) async {
    final SharedPreferences preference = await file;
    _partySet.add(party);

    // Now convert the set to a list as the jsonEncoder cannot encode
    // a set but a list.
    final partyListMap = _partySet.map((e) => e.toJson()).toList();

    await preference.setString('parties', jsonEncode(partyListMap));
  }

  Future<List<Party>> readParty() async {
    final SharedPreferences preference = await file;
    final content = preference.getString('parties');

    if (content == null || content.isEmpty) {
      return [];
    }

    final List<dynamic> jsonData = jsonDecode(content);
    final List<Party> parties =
        jsonData.map((e) => Party.fromJSON(e as Map<String, dynamic>)).toList();

    return parties;
  }

  Future<void> deleteParty(Party party) async {
    final SharedPreferences preference = await file;

    _partySet.removeWhere((e) => e.id == party.id);
    final partyListMap = _partySet.map((e) => e.toJson()).toList();

    await preference.setString('parties', jsonEncode(partyListMap));
  }

  Future<void> updateParty({
    required String id,
    required Party updatedParty,
  }) async {
    _partySet.removeWhere((e) => e.id == updatedParty.id);
    await writeParty(updatedParty);
  }
}
