import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';

class PostOwnerModel {
  final int id;
  final String name;
  final String username;
  final String? profilePictureUrl;

  PostOwnerModel({
    required this.id,
    required this.name,
    required this.username,
    this.profilePictureUrl,
  });

  factory PostOwnerModel.fromJson(Map<String, dynamic> json) {
    return PostOwnerModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      profilePictureUrl: json['profile_picture_url'],
    );
  }

  PostOwnerEntity toEntity() {
    return PostOwnerEntity(
      id: id,
      name: name,
      username: username,
      profilePictureUrl: profilePictureUrl,
    );
  }
}