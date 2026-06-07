import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';

class UserCollectionModel extends UserCollectionEntity {
  const UserCollectionModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.isDefault,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserCollectionModel.fromJson(Map<String, dynamic> json) {
    return UserCollectionModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      isDefault: json['is_default'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static List<UserCollectionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => UserCollectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
