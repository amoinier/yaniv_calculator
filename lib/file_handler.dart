import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaniv_calculator/entity.dart';
import 'package:yaniv_calculator/party.dart';
import 'package:yaniv_calculator/player.dart';

enum Entities { players, parties }

String getSetKeyFromEntityType<T extends Entity>(T entity) =>
    entity is Party ? Entities.parties.name : Entities.players.name;

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
  static final Set<Player> _playerSet = {};

  getSet(String key) {
    return (key == Entities.parties.name ? _partySet : _playerSet);
  }

  Future<void> write<T extends Entity>(T entity) async {
    final key = getSetKeyFromEntityType(entity);
    final SharedPreferences preference = await file;

    getSet(key).add(entity);

    final partyListMap = getSet(key).map((e) => e.toJson()).toList();

    await preference.setString(Entities.parties.name, jsonEncode(partyListMap));
  }

  Future<List<Entity>> read(Entities entity) async {
    final SharedPreferences preference = await file;
    final content = preference.getString(entity.name);

    if (content == null || content.isEmpty) {
      return [];
    }

    final List<dynamic> jsonData = jsonDecode(content);

    if (entity.name == Entities.parties.name) {
      _partySet.clear();
      _partySet.addAll(
        jsonData.map((e) => Party.fromJSON(e as Map<String, dynamic>)).toList(),
      );

      return jsonData
          .map((e) => Party.fromJSON(e as Map<String, dynamic>))
          .toList();
    }

    if (entity.name == Entities.players.name) {
      _playerSet.clear();
      _playerSet.addAll(
        jsonData
            .map((e) => Player.fromJSON(e as Map<String, dynamic>))
            .toList(),
      );

      return jsonData
          .map((e) => Party.fromJSON(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<void> delete<T extends Entity>(T entity) async {
    final key = getSetKeyFromEntityType(entity);
    final SharedPreferences preference = await file;

    getSet(key).removeWhere((e) => e.id == entity.id);
    final entities = getSet(key).map((e) => e.toJson()).toList();

    await preference.setString(Entities.parties.name, jsonEncode(entities));
  }

  Future<void> update<T extends Entity>({
    required String id,
    required T updatedEntity,
  }) async {
    final key = getSetKeyFromEntityType(updatedEntity);

    getSet(key).removeWhere((e) => e.id == updatedEntity.id);
    await write(updatedEntity);
  }
}
