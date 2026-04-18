import 'package:archilink/features/Chat/domain/entity/reaction_entity.dart';
import 'package:archilink/features/Chat/domain/entity/sender_entity.dart';

class MessageEntity {
  final int id;
  final int chatId;
  final String content;
  final DateTime? sentAt;
  final DateTime? editedAt;
  final SenderEntity sender;
  final List<int> receiptUserIds;
  final List<ReactionEntity> reactions;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    this.sentAt,
    this.editedAt,
    required this.sender,
    required this.receiptUserIds,
    required this.reactions,
  });
}