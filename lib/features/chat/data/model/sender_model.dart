import 'package:archilink/features/Chat/domain/entity/sender_entity.dart';

class SenderModel extends SenderEntity {
  const SenderModel({
    required super.id,
    required super.name,
    required super.username,
    super.userAvatar,
    super.country,
    super.city,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      userAvatar: json['user_avatar'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
    );
  }
}
