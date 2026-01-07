
import 'package:archilink/features/Auth/domain/entity/user_entity.dart';

class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      username: username,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}