import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;
  final int? code;
  final Response<dynamic>? response;

  const AppException({required this.message, this.code, this.response});

  static AppException handelDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 401:
            return const UnauthorizedException();
          case 403:
            return const ForbiddenException();
          case 404:
            return const NotFoundException();
          case 301:
            return ValidationException(response: error.response);
          default:
            return ServerException(
              message: error.response?.data['message'] ?? 'Server Error',
              code: statusCode,
            );
        }
      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request cancelled');
      case DioExceptionType.unknown:
      default:
        return const UnknownException();
    }
  }
}

class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized'});
}

class ForbiddenException extends AppException {
  const ForbiddenException({super.message = 'Access denied'});
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Resource not found'});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection'});
}

class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timeout'});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Cache error'});
}

class ValidationException extends AppException {
  const ValidationException({
    super.message = 'validation Error',
    super.response,
  });
}

class UnknownException extends AppException {
  const UnknownException({super.message = 'Unexpected error occurred'});
}
