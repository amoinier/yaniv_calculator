abstract class Entity {
  final String id;

  Entity({required this.id});

  Entity.fromJSON(Map<String, dynamic> map, this.id);
  Map<String, dynamic> toJson();
}
