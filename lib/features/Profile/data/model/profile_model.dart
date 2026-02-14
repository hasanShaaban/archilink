import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';

class ProfileModel {
  final String name;
  final String username;
  final String email;
  final String? bio;
  final String? location;
  final String? profilePictureUrl;

  const ProfileModel({
    required this.name,
    required this.username,
    required this.email,
    this.bio,
    this.location,
    this.profilePictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      name: name,
      username: username,
      email: email,
      bio: bio,
      location: location,
      profilePictureUrl: profilePictureUrl,
    );
  }
}
