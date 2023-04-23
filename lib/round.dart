class RoundWithoutBonus {
  final List<int> score;
  final String? asafPlayerId;

  RoundWithoutBonus(this.score, this.asafPlayerId);
}

class Round {
  final List<int> score;
  final List<int> bonus;
  final String? asafPlayerId;

  Round(this.score, this.bonus, this.asafPlayerId);

  static Map<String, dynamic> toJson(Round value) => {
        'score': value.score,
        'bonus': value.bonus,
        'asafPlayerId': value.asafPlayerId
      };
}
