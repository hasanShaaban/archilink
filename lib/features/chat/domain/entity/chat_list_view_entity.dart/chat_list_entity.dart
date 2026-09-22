import 'chat_entity.dart';
import 'pagination_entity.dart';

class ChatListEntity {
  final String? status;
  final String? message;
  final List<ChatEntity> chats;
  final PaginationEntity pagination;

  const ChatListEntity({
    this.status,
    this.message,
    required this.chats,
    required this.pagination,
  });
}

