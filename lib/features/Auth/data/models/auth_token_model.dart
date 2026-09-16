

import 'package:archilink/features/Auth/domain/entity/auth_token.dart';

class AuthTokenModel {
  final String accessToken;
  final String tokenType;
  final String username;
  final String? role;

  AuthTokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.username,
    this.role,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    String? role;
    if (json['role'] is String) {
      role = json['role'];
    } else if (json['user'] is Map && json['user']['role'] is String) {
      role = json['user']['role'];
    } else if (json['profile'] is Map && json['profile']['role'] is String) {
      role = json['profile']['role'];
    }

    final username = (json['username'] ??
            (json['user'] is Map ? json['user']['username'] : null) ??
            '') as String;

    return AuthTokenModel(
      accessToken: (json['access_token'] ?? json['token'] ?? '') as String,
      tokenType: (json['token_type'] ?? 'Bearer') as String,
      username: username,
      role: role?.toLowerCase().trim(),
    );
  }

  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      tokenType: tokenType,
      username: username,
      role: role,
    );
  }
}
