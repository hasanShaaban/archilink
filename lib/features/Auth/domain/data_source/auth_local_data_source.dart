abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> clearToken();
  Future<void> saveUsername(String username);
  String? getUsername();
  Future<void> clearUsername();
}