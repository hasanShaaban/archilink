import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';

Failure mapExceptionToFailure(AppException exception){
  if(exception is UnauthorizedException){
    return const UnauthorizedFailure();
  }else if (exception is ForbiddenException){
    return const ForbiddenFailure();
  }else if (exception is NotFoundException){
    return const NotFoundFailure();
  }else if (exception is NetworkException){
    return const NetworkFailure();
  }else if (exception is TimeoutException){
    return const TimeoutFailure();
  }else if(exception is CacheException){
    return const CacheFailure();
  }else if (exception is ServerException){
    return ServerFailure(message: exception.message);
  }else {
    return const UnknownFailure();
  }
}