
import 'package:archilink/features/Auth/domain/entity/profile_record_entity.dart';

class ProfileRecordModel {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileRecordModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileRecordModel.fromJson(Map<String, dynamic> json) {
    return ProfileRecordModel(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  ProfileRecordEntity toEntity() {
    return ProfileRecordEntity(
      id: id,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}