import 'package:archilink/features/Post_Details/domain/entity/add_comment_response_entity.dart';

class AddCommentResponseModel extends AddCommentResponseEntity {
  const AddCommentResponseModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.body,
    required super.createdAt,
    required super.updatedAt,
    super.parentId,
  });

  factory AddCommentResponseModel.fromJson(Map<String, dynamic> json) {
    return AddCommentResponseModel(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      parentId: json['parent_id'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}