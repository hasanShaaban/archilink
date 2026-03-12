import 'package:archilink/features/Post_Details/data/models/comment_owner_model.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.body,
    required super.createdAt,
    required super.owner,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      body: json['body'],
      createdAt: json['created_at'],
      owner: CommentOwnerModel.fromJson(json['owner']),
    );
  }
}
