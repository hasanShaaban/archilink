import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Auth/data/models/auth_token_model.dart';
import 'package:archilink/features/Auth/data/models/register_model.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_remote_data_source.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.post<Map<String, dynamic>>(
        'account-center/login',
        body: {'email': email, 'password': password},
      );
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid login response');
      }
      return AuthTokenModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<RegisterModel> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String username,
    required String role,
    String? phone,
  }) async {
    try {
      final response = await apiService.post<Map<String, dynamic>>(
        'account-center/register',
        body: {
          "base": {
            "name": name,
            "username": username,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
          },
          "role": role,
          "login": true,//TODO add phone later
        },
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid register response');
      }
      return RegisterModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
  
  @override
  Future<bool> checkUsername({required String username}) async{
    try{
      final response = await apiService.get('account-center/check-availability/$username');
      final data = response.data;
      if(data == null){
        throw ServerException(message: 'Invalid check username response');
      }
      return data['data']['available'] as bool;
    }on DioException catch(e){
      throw AppException.handelDioException(e);
    }
  }
}
