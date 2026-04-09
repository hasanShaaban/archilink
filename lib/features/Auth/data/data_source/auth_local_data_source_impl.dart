import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource{
  final LocalStorage storage;
  static const _tokenKey = 'ACCESS_TOKEN';
  static const _usernameKey = 'USERNAME';
  static const _rememberMeKey = 'REMEMBERME';
  static const _tokenRegisteredKey = 'IS_FCM_TOKEN_REGISTERED';

  AuthLocalDataSourceImpl(this.storage);
  @override
  Future<void> clearToken() async{
    await storage.delete(_tokenKey);
  }

  @override
  String? getToken() {
    return storage.read<String>(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async{
    await storage.write(_tokenKey, token);
  }
  
  @override
  Future<void> clearUsername() {
    // TODO: implement clearUsername
    throw UnimplementedError();
  }
  
  @override
  String? getUsername() {
    return storage.read<String>(_usernameKey);
  }
  
  @override
  Future<void> saveUsername(String username) async{
    await storage.write(_usernameKey, username);
  }
  
  @override
  Future<void> setRememberMe(bool rememberMe) async{
    await storage.write(_rememberMeKey, rememberMe);
  }
  
  @override
  bool? getRemeberMe() {
    return storage.read<bool>(_rememberMeKey);
  }
  
  @override
  bool isTokenRegistered() {
    return storage.read<bool>(_tokenRegisteredKey) ?? false;
  }
  
  @override
  Future<void> setTokenRegistered(bool value) async{
    await storage.write(_tokenRegisteredKey, value);
  }
}