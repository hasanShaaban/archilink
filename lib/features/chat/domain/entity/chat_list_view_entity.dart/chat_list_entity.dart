import 'chat_entity.dart';
import 'pagination_entity.dart';

class ChatListEntity {
  final List<ChatEntity> chats;
  final PaginationEntity pagination;

  const ChatListEntity({
    required this.chats,
    required this.pagination,
  });
}
