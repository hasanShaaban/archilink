import 'package:archilink/features/Create_Post/data/models/create_post_model.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_response_entity.dart';

class CreatePostResponseModel extends CreatePostResponseEntity {
  const CreatePostResponseModel({
    required super.status,
    required super.message,
    required super.post,
  });

  factory CreatePostResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final postJson = data['post'] as Map<String, dynamic>;
    return CreatePostResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      post: CreatePostModel.fromJson(postJson),
    );
  }
}
