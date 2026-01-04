import 'package:archilink/core/network/interceptors/auth_interceptor.dart';
import 'package:archilink/core/network/interceptors/error_interceptor.dart';
import 'package:archilink/core/network/network_config.dart';
import 'package:dio/dio.dart';

import 'interceptors/log_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required AuthInterceptor authInterceptor,
    required ErrorInterceptor errorInterceptor,
    required LogInterseptor logInterceptor,
  }){
    dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.baseURL,
        connectTimeout: NetworkConfig.connectTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,
        headers: NetworkConfig.defaultHeaders,
        responseType: ResponseType.json,
      )
    );

    dio.interceptors.addAll([
      authInterceptor,
      errorInterceptor,
      logInterceptor
    ]);
  }
}