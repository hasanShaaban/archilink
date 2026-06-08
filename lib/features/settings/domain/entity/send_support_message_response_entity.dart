import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/sender_entity.dart';

class SendSupportMessageResponseEntity {
  final int id;
  final int chatId;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;
  final SenderEntity sender;

  const SendSupportMessageResponseEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.sentAt,
    this.editedAt,
    required this.sender,
  });

  MessageEntity toMessageEntity() {
    return MessageEntity(
      id: id,
      chatId: chatId,
      content: content,
      sentAt: sentAt,
      editedAt: editedAt,
      sender: sender,
      receiptUserIds: const [],
      reactions: const [],
    );
  }
}
