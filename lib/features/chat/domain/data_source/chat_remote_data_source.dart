import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/messages_reponse_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_list_entity.dart';

abstract class ChatRemoteDataSource {
  Future<MessagesResponseEntity> fetchMessages({
    required int conversationId,
    required int page,
  });
  Future<ChatListEntity> getChats();
}
