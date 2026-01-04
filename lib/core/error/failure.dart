
import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable{
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message,];
}


class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timeout'});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Invalid credentials'});
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.message = 'Access denied'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Unexpected error occurred'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Not Found'});
}