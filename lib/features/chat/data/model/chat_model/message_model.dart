import 'package:archilink/features/Chat/data/model/chat_model/reaction_model.dart';
import 'package:archilink/features/Chat/data/model/chat_model/sender_model.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.content,
    super.sentAt,
    super.editedAt,
    required super.sender,
    required super.receiptUserIds,
    required super.reactions,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: (json['id'] as num).toInt(),
      chatId: ((json['chat_id'] ?? json['chatId']) as num).toInt(),
      content: (json['content'] ?? '') as String,
      sentAt: json['sent_at'] != null
          ? DateTime.tryParse(json['sent_at'].toString())
          : null,
      editedAt: json['edited_at'] != null
          ? DateTime.tryParse(json['edited_at'].toString())
          : null,
      sender: json['sender'] is Map<String, dynamic>
          ? SenderModel.fromJson(json['sender'] as Map<String, dynamic>)
          : const SenderModel(id: 0, name: '', username: ''),
      receiptUserIds: (json['receipts'] as List?)
              ?.map((r) => (r is Map ? (r['user_id'] as num).toInt() : (r as num).toInt()))
              .toList() ??
          (json['receipt_user_ids'] as List?)
              ?.map((r) => (r as num).toInt())
              .toList() ??
          [],
      reactions: (json['reactions'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(ReactionModel.fromJson)
              .toList() ??
          [],
    );
  }
}
