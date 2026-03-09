import 'package:archilink/features/Home/domain/entity/tag_entity.dart';

class TagModel {
  final String name;
  final int id;

  TagModel({required this.name, required this.id});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(name: json['name'], id: json['id']);
  }

  TagEntity toEntity() {
    return TagEntity(id: id, name: name);
  }
}
