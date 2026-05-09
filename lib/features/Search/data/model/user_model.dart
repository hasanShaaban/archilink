import 'package:archilink/features/Search/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    super.userAvatar,
    required super.isVerified,
    super.country,
    super.city,
    required super.isFollowing,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      userAvatar: json['user_avatar'] as String?,
      isFollowing: json['is_following'] as bool,
      isVerified: json['is_verified'] as bool,
      country: json['country'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'user_avatar': userAvatar,
    'is_verified': isVerified,
    'is_following': isFollowing,
    'country': country,
    'city': city,
  };
}
