import 'contact_entity.dart';
import 'last_message_entity.dart';

enum ChatType { private, group }

class ChatEntity {
  final int id;
  final ChatType type;
  final String chatName;
  final String? chatCoverUrl;
  final ContactEntity contact;
  final LastMessageEntity lastMessage;
  final int unreadMessagesCount;

  const ChatEntity({
    required this.id,
    required this.type,
    required this.chatName,
    this.chatCoverUrl,
    required this.contact,
    required this.lastMessage,
    required this.unreadMessagesCount,
  });
}
