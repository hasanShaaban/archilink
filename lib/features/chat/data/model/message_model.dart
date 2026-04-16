import 'package:archilink/features/Chat/data/model/reaction_model.dart';
import 'package:archilink/features/Chat/data/model/sender_model.dart';
import 'package:archilink/features/Chat/domain/entity/message_entity.dart';

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
      id: json['id'] as int,
      chatId: json['chat_id'] as int,
      content: json['content'] as String,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'] as String)
          : null,
      sender: SenderModel.fromJson(json['sender'] as Map<String, dynamic>),
      receiptUserIds: (json['receipts'] as List)
          .map((r) => r['user_id'] as int)
          .toList(),
      reactions: (json['reactions'] as List)
          .map((r) => ReactionModel.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}
