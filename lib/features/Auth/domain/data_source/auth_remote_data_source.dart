import 'package:archilink/features/Auth/data/models/auth_token_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login({required String email, required String password});
}