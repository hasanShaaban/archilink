import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';

Failure mapExceptionToFailure(AppException exception) {
  if (exception is UnauthorizedException) {
    return const UnauthorizedFailure();
  } else if (exception is ForbiddenException) {
    return const ForbiddenFailure();
  } else if (exception is NotFoundException) {
    return const NotFoundFailure();
  } else if (exception is NetworkException) {
    return const NetworkFailure();
  } else if (exception is TimeoutException) {
    return const TimeoutFailure();
  } else if (exception is CacheException) {
    return const CacheFailure();
  } else if (exception is ServerException) {
    return ServerFailure(message: exception.message);
  } else if (exception is ValidationException) {
    final data = exception.response?.data;
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstErrorList = errors.values.first;
        if (firstErrorList is List && firstErrorList.isNotEmpty) {
          return ValidationFailure(
            message: firstErrorList.first.toString(),
            fieldErrors: errors.map(
              (key, value) => MapEntry(
                key,
                value is List
                    ? value.map((e) => e.toString()).toList()
                    : [value.toString()],
              ),
            ),
          );
        }
      }
      if (data['message'] != null) {
        return ValidationFailure(message: data['message'].toString());
      }
    }
    return const ValidationFailure(message: 'Validation Error');
  } else {
    return const UnknownFailure();
  }
}
