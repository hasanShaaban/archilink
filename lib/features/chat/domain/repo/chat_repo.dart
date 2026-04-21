import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/messages_reponse_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_list_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  Future<Either<Failure, MessagesResponseEntity>> fetchMessages({
    required int conversationId,
    required int page,
  });

  Future<Either<Failure, ChatListEntity>> getChats();
}
