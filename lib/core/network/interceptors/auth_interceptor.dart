
import 'package:archilink/core/network/websocket/pusher_client.dart';
import 'package:archilink/core/network/websocket/reverb_client.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource local;
  final ReverbClient pusherClient;
  // final PusherClient pusherClient;

  AuthInterceptor(this.local, this.pusherClient);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = local.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final socketId = pusherClient.socketId;
    if (socketId != null) {
      options.headers['X-Socket-Id'] = socketId;
    }
    handler.next(options);
  }
}
