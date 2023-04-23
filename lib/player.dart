import 'package:yaniv_calculator/entity.dart';
import 'package:yaniv_calculator/file_handler.dart';

class Player implements Entity {
  @override
  final String id;
  final String name;
  final String image;

  Player({
    required this.id,
    required this.name,
    required this.image,
  });

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

  Future<void> write() async {
    await FileHandler.instance.write(this);
  }

  static Future<List<Player>> read() async {
    final players = await FileHandler.instance.read(Entities.players);

    return players.isNotEmpty ? players as List<Player> : List<Player>.empty();
  }

  Future<void> update() async {
    await FileHandler.instance.update(id: id, updatedEntity: this);
  }

  Future<void> delete() async {
    await FileHandler.instance.delete(this);
  }

  List<Object> get props => [id, name, image];
}
