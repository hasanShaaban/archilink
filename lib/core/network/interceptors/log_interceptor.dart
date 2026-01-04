import 'dart:developer';

import 'package:dio/dio.dart';

class LogInterseptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('[API REQUEST] ${options.method} ${options.path}');
    log('Headers: ${options.headers}');
    log('Body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('[API RESPONSE] ${response.statusCode}');
    log('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('[API ERROR] ${err.response?.statusCode}');
    log('Data: ${err.response?.data}');
    handler.next(err);
  }
}