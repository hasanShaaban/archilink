import 'package:archilink/features/Post_Details/domain/entity/comment_owner_entity.dart';

class CommentOwnerModel extends CommentOwnerEntity {
  const CommentOwnerModel({
    required super.id,
    required super.name,
    required super.username,
    super.profilePictureUrl,
  });

  factory CommentOwnerModel.fromJson(Map<String, dynamic> json) {
    return CommentOwnerModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      profilePictureUrl: json['profile_picture_url'],
    );
  }
}