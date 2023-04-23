import 'package:yaniv_calculator/entity.dart';
import 'package:yaniv_calculator/file_handler.dart';

class Party implements Entity {
  @override
  final String id;
  final List<String> players;
  final List<Map<String, List<int>>> rounds;
  final String creationDate;
  int maxPoints = 200;
  int asafPoints = 30;
  int cardsNumber = 5;

  Party({
    required this.id,
    required this.players,
    required this.rounds,
    required this.creationDate,
    maxPoints,
    asafPoints,
  });

  Party.fromJSON(Map<String, dynamic> map)
      : id = map['id'].toString(),
        creationDate = map['creationDate'].toString(),
        players = map['players'].cast<String>(),
        maxPoints = map['maxPoints']?.toInt() ?? 200,
        asafPoints = map['asafPoints']?.toInt() ?? 30,
        cardsNumber = map['cardsNumber']?.toInt() ?? 5,
        rounds = List<Map<String, List<int>>>.from(
          map['rounds'].map((e) => {'score': List<int>.from(e['score'])}),
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'players': players,
      'rounds': rounds,
      'creationDate': creationDate,
      'maxPoints': maxPoints,
      'asafPoints': asafPoints,
      'cardsNumber': cardsNumber,
    };
  }

  Future<void> write() async {
    await FileHandler.instance.write(this);
  }

  static Future<List<Party>> read() async {
    return await FileHandler.instance.read(Entities.parties) as List<Party>;
  }

  Future<void> update() async {
    await FileHandler.instance.update(id: id, updatedEntity: this);
  }

  Future<void> delete() async {
    await FileHandler.instance.delete(this);
  }

  List<Object> get props =>
      [id, players, rounds, creationDate, maxPoints, asafPoints, cardsNumber];
}
