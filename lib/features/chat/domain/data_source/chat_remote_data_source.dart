import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/messages_reponse_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_list_entity.dart';

abstract class ChatRemoteDataSource {
  Future<MessagesResponseEntity> fetchMessages({
    required int conversationId,
    required int page,
  });
  Future<ChatListEntity> getChats();
  Future<MessageEntity> sendMessage({
    required int conversationId,
    required String content,
  });

  Future<void> deleteMessage({
    required int conversationId,
    required int messageId,
  });

  Future<void> reactMessage({
    required int conversationId,
    required int messageId,
    required String reaction,
  });

  Future<void> removeReaction({
    required int conversationId,
    required int messageId,
  });

  /// POST chats/{conversationId}/seen
  /// Body: { "last_seen_message_id": lastSeenMessageId }
  Future<void> markMessagesSeen({
    required int conversationId,
    required int lastSeenMessageId,
  });
}
