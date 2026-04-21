

import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/last_message_entity.dart';

class LastMessageModel extends LastMessageEntity {
  const LastMessageModel({
    required super.id,
    required super.chatId,
    required super.content,
    required super.sentAt,
    super.editedAt,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json['id'] as int,
      chatId: json['chat_id'] as int,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'content': content,
      'sent_at': sentAt.toIso8601String(),
      'edited_at': editedAt?.toIso8601String(),
    };
  }
}
