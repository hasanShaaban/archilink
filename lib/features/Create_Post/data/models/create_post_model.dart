import 'package:archilink/features/Create_Post/domain/entity/create_post_entity.dart';

class CreatePostModel extends CreatePostEntity {
  const CreatePostModel({
    required super.id,
    required super.body,
    required super.privacy,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
      id: json['id'] as int,
      body: json['body'] as String,
      privacy: json['privacy'] as String,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
