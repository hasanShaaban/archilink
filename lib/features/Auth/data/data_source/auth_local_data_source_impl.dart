import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource{
  final LocalStorage storage;
  static const _tokenKey = 'ACCESS_TOKEN';

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
}