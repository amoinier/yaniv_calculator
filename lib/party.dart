class Party {
  final String id;
  final List<String> players;
  final List<Map<String, List<int>>> rounds;

  const Party({required this.id, required this.players, required this.rounds});

  Party.fromJSON(Map<String, dynamic> map)
      : id = map['id'].toString(),
        players = map['players'].cast<String>(),
        rounds = List<Map<String, List<int>>>.from(
          map['rounds'].map((e) => {'score': List<int>.from(e['score'])}),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'players': players,
      'rounds': rounds,
    };
  }

  List<Object> get props => [id, players, rounds];
}
