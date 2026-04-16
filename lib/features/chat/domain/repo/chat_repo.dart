import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Chat/domain/entity/messages_reponse_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  Future<Either<Failure, MessagesResponseEntity>> fetchMessages({
    required int conversationId,
    required int page,
  });
}
