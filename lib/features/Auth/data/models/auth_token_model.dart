

import 'package:archilink/features/Auth/domain/entity/auth_token.dart';

class AuthTokenModel {
  final int id;
  final String username;
  final String role;
  final String accessToken;
  final String tokenType;
  final String? status;
  final String? message;

  AuthTokenModel({
    required this.id,
    required this.username,
    required this.role,
    required this.accessToken,
    required this.tokenType,
    this.status,
    this.message,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    String role = '';
    if (data['role'] is String) {
      role = data['role'] as String;
    } else if (json['role'] is String) {
      role = json['role'] as String;
    } else if (data['user'] is Map && data['user']['role'] is String) {
      role = data['user']['role'] as String;
    } else if (data['profile'] is Map && data['profile']['role'] is String) {
      role = data['profile']['role'] as String;
    }

    final id = (data['id'] as num?)?.toInt() ??
        (json['id'] as num?)?.toInt() ??
        0;

    final username = (data['username'] ??
            json['username'] ??
            (data['user'] is Map ? data['user']['username'] : null) ??
            '') as String;

    final accessToken = (data['access_token'] ??
            data['token'] ??
            json['access_token'] ??
            json['token'] ??
            '') as String;

    final tokenType = (data['token_type'] ??
            json['token_type'] ??
            'Bearer') as String;

    return AuthTokenModel(
      id: id,
      username: username,
      role: role.toLowerCase().trim(),
      accessToken: accessToken,
      tokenType: tokenType,
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (message != null) 'message': message,
      'data': {
        'id': id,
        'username': username,
        'role': role,
        'access_token': accessToken,
        'token_type': tokenType,
      },
    };
  }

  AuthToken toEntity() {
    return AuthToken(
      id: id,
      username: username,
      role: role,
      accessToken: accessToken,
      tokenType: tokenType,
    );
  }
}

