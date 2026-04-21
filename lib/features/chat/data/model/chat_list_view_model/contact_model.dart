

import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.id,
    required super.name,
    required super.username,
    super.userAvatar,
    required super.isVerified,
    required super.country,
    required super.city,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      userAvatar: json['user_avatar'] as String?,
      isVerified: json['is_verified'] as bool,
      country: json['country'] as String,
      city: json['city'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'user_avatar': userAvatar,
      'is_verified': isVerified,
      'country': country,
      'city': city,
    };
  }
}
