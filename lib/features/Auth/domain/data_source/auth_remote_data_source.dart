import 'package:archilink/features/Auth/data/models/auth_token_model.dart';
import 'package:archilink/features/Auth/data/models/register_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  });
  Future<RegisterModel> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String username,
    required String role,
    String? phone,
  });
  Future<bool> checkUsername({required String username});
  Future<bool> registerFCM(String token);
}
