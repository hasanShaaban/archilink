abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> clearToken();
  Future<void> saveUsername(String username);
  String? getUsername();
  Future<void> clearUsername();
  Future<void> saveRole(String role);
  String? getRole();
  Future<void> clearRole();
  Future<void> saveUserId(int id);
  int? getUserId();
  Future<void> clearUserId();
  Future<void> setRememberMe(bool rememberMe);
  bool? getRemeberMe();
  Future<void> setTokenRegistered(bool value);
  bool isTokenRegistered();
}