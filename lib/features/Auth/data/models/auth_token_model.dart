

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
    return AuthTokenModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      username: json['username'],
      role: json['role'],
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
