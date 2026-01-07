import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor{
  final AuthLocalDataSource local;

  AuthInterceptor(this.local);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = local.getToken();
    if(token != null){
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}