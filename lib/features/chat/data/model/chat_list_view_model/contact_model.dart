

import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.id,
    required super.name,
    required super.username,
    super.avatar,
    super.isVerified,
    super.role,
    super.country,
    super.city,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      avatar: (json['avatar'] ?? json['user_avatar']) as String?,
      isVerified: json['is_verified'] as bool?,
      role: json['role'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
      'is_verified': isVerified,
      'role': role,
      'country': country,
      'city': city,
    };
  }
}

