
import 'package:archilink/features/Auth/domain/entity/profile_entity.dart';

class ProfileModel {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}