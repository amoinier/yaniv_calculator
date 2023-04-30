import 'package:uuid/uuid.dart';
import 'package:yaniv_calculator/entity.dart';
import 'package:yaniv_calculator/file_handler.dart';

const uuid = Uuid();

class Player implements Entity {
  @override
  late String id;
  late String name;
  late String? image;

  Player({
    String? id,
    required this.name,
    this.image,
  }) {
    this.id = id ?? uuid.v4();
  }

  Player.fromJSON(Map<String, dynamic> map)
      : id = map['id'].toString(),
        name = map['name'].toString(),
        image = map['image'].toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  static void init() {
    FileHandler.instance.read(Entities.players);
  }

  static List<Player> read() {
    final players = FileHandler.instance.getPlayer();

    return players.toList();
  }

  static Player? findPlayer(String id) {
    final players = read();
    final findedPlayer = players.firstWhere(
      (player) => player.id == id,
      orElse: () => Player(name: ''),
    );

    return findedPlayer.name.isNotEmpty ? findedPlayer : null;
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

  List<Object> get props => [id, name, image ?? ''];
}
