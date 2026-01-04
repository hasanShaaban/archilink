
class AuthToken {
  final String accessToken;
  final String tokenType;

  const AuthToken({
    required this.accessToken,
    required this.tokenType,
  });

  String get authorizationHeader => '$tokenType $accessToken';
}
