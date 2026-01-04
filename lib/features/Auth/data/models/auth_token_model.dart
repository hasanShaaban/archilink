

import 'package:archilink/features/Auth/domain/entity/auth_token.dart';

class AuthTokenModel {
  final String accessToken;
  final String tokenType;

  AuthTokenModel({
    required this.accessToken,
    required this.tokenType,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      tokenType: tokenType,
    );
  }
}
