
class AuthToken {
  final String accessToken;
  final String tokenType;
  final String username;

  const AuthToken({
    required this.accessToken,
    required this.tokenType, required this.username,
  });

  String get authorizationHeader => '$tokenType $accessToken';
}
