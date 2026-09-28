import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/sender_entity.dart';

class SenderModel extends SenderEntity {
  const SenderModel({
    required super.id,
    required super.name,
    required super.username,
    super.userAvatar,
    super.country,
    super.city,
    super.role,
    super.isVerified,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      userAvatar: (json['avatar'] ?? json['user_avatar'] ?? json['profile_photo_url'] ?? json['image']) as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      role: json['role'] as String?,
      isVerified: json['is_verified'] as bool?,
    );
  }
}
