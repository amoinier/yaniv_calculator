import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:yaniv_calculator/party.dart';

class FileHandler {
  // Makes this a singleton class, as we want only want a single
  // instance of this object for the whole application
  FileHandler._privateConstructor();
  static final FileHandler instance = FileHandler._privateConstructor();
  static File? _file;

  static const _fileName = 'user_file.txt';

  // Get the data file
  Future<File> get file async {
    if (_file != null) return _file!;

    _file = await _initFile();
    return _file!;
  }

  // Inititalize file
  Future<File> _initFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    return !File('$path/$_fileName').existsSync()
        ? await File('$path/$_fileName').create(recursive: true)
        : File('$path/$_fileName');
  }

  static final Set<Party> _partySet = {};

  Future<void> writeParty(Party party) async {
    final File fl = await file;
    _partySet.add(party);

    // Now convert the set to a list as the jsonEncoder cannot encode
    // a set but a list.
    final partyListMap = _partySet.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(partyListMap));
  }

  Future<List<Party>> readParty() async {
    final File fl = await file;
    final content = await fl.readAsString();

    if (content.isEmpty) {
      return [];
    }

    final List<dynamic> jsonData = jsonDecode(content);
    final List<Party> parties =
        jsonData.map((e) => Party.fromJSON(e as Map<String, dynamic>)).toList();

    return parties;
  }

  Future<void> deleteParty(Party party) async {
    final File fl = await file;

    _partySet.removeWhere((e) => e == party);
    final partyListMap = _partySet.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(partyListMap));
  }

  Future<void> updateParty({
    required String id,
    required Party updatedParty,
  }) async {
    _partySet.removeWhere((e) => e.id == updatedParty.id);
    await writeParty(updatedParty);
  }
}
