
class AuthToken {
  final int id;
  final String username;
  final String role;
  final String accessToken;
  final String tokenType;

  const AuthToken({
    required this.id,
    required this.username,
    required this.role,
    required this.accessToken,
    required this.tokenType,
  });

  String get authorizationHeader => '$tokenType $accessToken';
}

