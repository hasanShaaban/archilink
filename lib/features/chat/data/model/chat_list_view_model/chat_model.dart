

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
    required super.lastMessage,
    required super.unreadMessagesCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as int,
      type: _parseType(json['type'] as String),
      chatName: json['chat_name'] as String,
      chatCoverUrl: json['chat_cover_url'] as String?,
      contact: ContactModel.fromJson(json['contact'] as Map<String, dynamic>),
      lastMessage: LastMessageModel.fromJson(
        json['last_message'] as Map<String, dynamic>,
      ),
      unreadMessagesCount: json['unread_messages_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'chat_name': chatName,
      'chat_cover_url': chatCoverUrl,
      'contact': (contact as ContactModel).toJson(),
      'last_message': (lastMessage as LastMessageModel).toJson(),
      'unread_messages_count': unreadMessagesCount,
    };
  }

  static ChatType _parseType(String value) {
    return ChatType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChatType.private,
    );
  }
}
