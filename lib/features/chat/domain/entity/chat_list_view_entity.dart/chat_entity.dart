import 'contact_entity.dart';
import 'last_message_entity.dart';

enum ChatType { private, group }

class ChatEntity {
  final int id;
  final ChatType type;
  final String chatName;
  final String? chatCoverUrl;
  final ContactEntity contact;
  final DateTime? latestMessageAt;
  final LastMessageEntity? lastMessage;
  final int unreadCount;
  final int? readInboxMaxId;
  final int? readOutboxMaxId;

  const ChatEntity({
    required this.id,
    required this.type,
    required this.chatName,
    this.chatCoverUrl,
    required this.contact,
    this.latestMessageAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.readInboxMaxId,
    this.readOutboxMaxId,
  });

  /// Backward-compatible alias for unreadCount
  int get unreadMessagesCount => unreadCount;

  /// Alias matching API field latest_message
  LastMessageEntity? get latestMessage => lastMessage;
}

