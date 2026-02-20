import 'package:archilink/features/Home/data/model/post_owner_model.dart';
import 'package:archilink/features/Home/domain/entity/post_entity.dart';

class PostModel {
  final int id;
  final String body;
  final DateTime createdAt;
  final PostOwnerModel owner;
  final List<String> tags;

  PostModel({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.tags,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      owner: PostOwnerModel.fromJson(json['owner']),
      tags: List<String>.from(json['tags']),
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      body: body,
      createdAt: createdAt,
      owner: owner.toEntity(),
      tags: tags,
    );
  }
}