

import 'package:archilink/features/Chat/data/model/chat_list_view_model/contact_model.dart';
import 'package:archilink/features/Chat/data/model/chat_list_view_model/last_message_model.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.type,
    required super.chatName,
    super.chatCoverUrl,
    required super.contact,
    super.latestMessageAt,
    super.lastMessage,
    super.unreadCount = 0,
    super.readInboxMaxId,
    super.readOutboxMaxId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final messageData =
        (json['latest_message'] ?? json['last_message']) as Map<String, dynamic>?;

    return ChatModel(
      id: json['id'] as int,
      type: _parseType(json['type'] as String?),
      chatName: (json['chat_name'] as String?) ?? '',
      chatCoverUrl: json['chat_cover_url'] as String?,
      contact: ContactModel.fromJson(json['contact'] as Map<String, dynamic>),
      latestMessageAt: json['latest_message_at'] != null
          ? DateTime.tryParse(json['latest_message_at'].toString())
          : null,
      lastMessage: messageData != null
          ? LastMessageModel.fromJson(messageData)
          : null,
      unreadCount:
          (json['unread_count'] ?? json['unread_messages_count'] ?? 0) as int,
      readInboxMaxId: (json['read_inbox_max_id'] as num?)?.toInt(),
      readOutboxMaxId: (json['read_outbox_max_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'chat_name': chatName,
      'chat_cover_url': chatCoverUrl,
      'contact': (contact as ContactModel).toJson(),
      'latest_message_at': latestMessageAt?.toIso8601String(),
      'latest_message': lastMessage != null
          ? (lastMessage as LastMessageModel).toJson()
          : null,
      'unread_count': unreadCount,
      'read_inbox_max_id': readInboxMaxId,
      'read_outbox_max_id': readOutboxMaxId,
    };
  }

  static ChatType _parseType(String? value) {
    if (value == null) return ChatType.private;
    return ChatType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ChatType.private,
    );
  }
}

