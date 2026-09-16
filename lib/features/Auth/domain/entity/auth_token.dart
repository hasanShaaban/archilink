
class AuthToken {
  final String accessToken;
  final String tokenType;
  final String username;
  final String? role;

  const AuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.username,
    this.role,
  });

  String get authorizationHeader => '$tokenType $accessToken';
}
