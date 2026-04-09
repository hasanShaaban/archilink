import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) {
    return dio.get<T>(path, queryParameters: query);
  }

  Future<Response<T>> post<T>(String path, {dynamic body}) {
    return dio.post<T>(path, data: body);
  }
  Future<Response<T>> patch<T>(String path, {dynamic body}) {
    return dio.patch<T>(path, data: body);
  }
  
  Future<Response<T>> postForm<T>(String path, {required FormData formData}) {
    return dio.post<T>(
      path,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  Future<Response<T>> put<T>(String path, {dynamic body}) {
    return dio.put<T>(path, data: body);
  }

  Future<Response<T>> delete<T>(String path) {
    return dio.delete<T>(path);
  }
}