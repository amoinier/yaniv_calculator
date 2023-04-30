import 'package:yaniv_calculator/entity.dart';
import 'package:yaniv_calculator/file_handler.dart';
import 'package:yaniv_calculator/round.dart';

const defaultMaxPoints = 200;
const defaultAsafPoints = 30;
const defaultCardNumber = 5;
const defaultBonusPoints = -50;

class Party implements Entity {
  @override
  final String id;
  final List<String> players;
  final List<Round> rounds;
  final String creationDate;
  int maxPoints = defaultMaxPoints;
  int asafPoints = defaultAsafPoints;
  int cardsNumber = defaultCardNumber;
  int bonusPoints = defaultBonusPoints;

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
        maxPoints = map['maxPoints']?.toInt() ?? defaultMaxPoints,
        asafPoints = map['asafPoints']?.toInt() ?? defaultAsafPoints,
        cardsNumber = map['cardsNumber']?.toInt() ?? defaultCardNumber,
        bonusPoints = map['bonusPoints']?.toInt() ?? defaultBonusPoints,
        rounds = List<Round>.from(
          map['rounds'].map(
            (e) => Round(
              List<int>.from(e['score']),
              List<int>.from(e['bonus']),
              e['asafPlayerId'].toString(),
            ),
          ),
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

  List<int> computeBonusFromNewScore(List<int> newScore, String? asafPlayerId) {
    final computedScore = computeScoreFromRound(rounds.length);

    return computedScore.asMap().entries.map((totalByPlayer) {
      final total = totalByPlayer.value + newScore[totalByPlayer.key];

      final asaf = asafPlayerId == players[totalByPlayer.key] ? asafPoints : 0;
      final bonus = total != 0 && total % 100 == 0 ? bonusPoints : 0;

      return asaf + bonus;
    }).toList();
  }

  void addNewRound(List<int> newScore, String? asafPlayerId) {
    rounds.add(
      Round(
        newScore,
        computeBonusFromNewScore(newScore, asafPlayerId),
        asafPlayerId,
      ),
    );

    update();
  }

  List<int> computeScoreFromRound(int roundToScore) {
    List<int> score = List<int>.generate(players.length, (index) => 0);
    for (int i = 0; i < roundToScore; i++) {
      rounds[i].score.asMap().entries.forEach(
        (value) {
          final bonus = rounds[i].bonus[value.key];

          score[value.key] = score[value.key] + value.value + bonus;
        },
      );
    }
    return score;
  }

  static List<Party> read() {
    final parties = FileHandler.getParty();

    return parties.toList();
  }

  static Future<List<Party>> readAsync() async {
    final parties = await FileHandler.instance.read(Entities.parties);

    return parties.isNotEmpty ? parties as List<Party> : List<Party>.empty();
  }

  Future<void> write() async {
    await FileHandler.instance.write(this);
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
