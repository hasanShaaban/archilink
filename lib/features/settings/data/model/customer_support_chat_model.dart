import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';

class CustomerSupportChatModel extends CustomerSupportChatEntity {
  const CustomerSupportChatModel({
    required super.id,
    required super.type,
    required super.chatName,
    super.chatCoverUrl,
    super.lastMessage,
    required super.unreadMessagesCount,
  });

  factory CustomerSupportChatModel.fromJson(Map<String, dynamic> json) {
    // If the input JSON is the full response wrapper containing a "data" object,
    // we extract the data object. Otherwise, we assume the input JSON is the data object itself.
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return CustomerSupportChatModel(
      id: data['id'] as int,
      type: data['type'] as String? ?? 'support',
      chatName: data['chat_name'] as String? ?? '',
      chatCoverUrl: data['chat_cover_url'] as String?,
      lastMessage: data['last_message'] != null
          ? CustomerSupportLastMessageModel.fromJson(
              data['last_message'] as Map<String, dynamic>,
            )
          : null,
      unreadMessagesCount: data['unread_messages_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'chat_name': chatName,
      'chat_cover_url': chatCoverUrl,
      'last_message': lastMessage != null
          ? CustomerSupportLastMessageModel.fromEntity(lastMessage!).toJson()
          : null,
      'unread_messages_count': unreadMessagesCount,
    };
  }
}

class CustomerSupportLastMessageModel extends CustomerSupportLastMessageEntity {
  const CustomerSupportLastMessageModel({
    required super.id,
    required super.chatId,
    required super.content,
    required super.sentAt,
    super.editedAt,
  });

  factory CustomerSupportLastMessageModel.fromJson(Map<String, dynamic> json) {
    return CustomerSupportLastMessageModel(
      id: json['id'] as int,
      chatId: json['chat_id'] as int,
      content: json['content'] as String? ?? '',
      sentAt: DateTime.parse(json['sent_at'] as String),
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'] as String)
          : null,
    );
  }

  factory CustomerSupportLastMessageModel.fromEntity(
      CustomerSupportLastMessageEntity entity) {
    return CustomerSupportLastMessageModel(
      id: entity.id,
      chatId: entity.chatId,
      content: entity.content,
      sentAt: entity.sentAt,
      editedAt: entity.editedAt,
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
