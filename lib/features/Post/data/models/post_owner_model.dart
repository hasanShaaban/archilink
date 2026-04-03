import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';

class PostOwnerModel {
  final int id;
  final String name;
  final String username;
  final String? profilePictureUrl;
  final String? city, country;

  PostOwnerModel({
    required this.id,
    required this.name,
    required this.username,
    this.profilePictureUrl,
    this.city,
    this.country,
  });

  factory PostOwnerModel.fromJson(Map<String, dynamic> json) {
    return PostOwnerModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      profilePictureUrl: json['user_avatar'],
      city: json['city'],
      country: json['country'],
    );
  }

  PostOwnerEntity toEntity() {
    return PostOwnerEntity(
      id: id,
      name: name,
      username: username,
      profilePictureUrl: profilePictureUrl,
      city: city,
      country: country,
    );
  }
}
