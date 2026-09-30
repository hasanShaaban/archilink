import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/messages_reponse_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_list_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  Future<Either<Failure, MessagesResponseEntity>> fetchMessages({
    required int conversationId,
    required int page,
  });

  Future<Either<Failure, ChatListEntity>> getChats();

  Future<Either<Failure, MessageEntity>> sendMessage({
    required int conversationId,
    required String content,
  });

  Future<Either<Failure, void>> deleteMessage({
    required int conversationId,
    required int messageId,
  });

  Future<Either<Failure, void>> reactMessage({
    required int conversationId,
    required int messageId,
    required String reaction,
  });

  Future<Either<Failure, void>> removeReaction({
    required int conversationId,
    required int messageId,
  });

  /// POST chats/{conversationId}/seen
  Future<Either<Failure, void>> markMessagesSeen({
    required int conversationId,
    required int lastSeenMessageId,
  });
}
