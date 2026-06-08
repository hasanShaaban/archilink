import 'package:archilink/features/Chat/data/model/chat_model/sender_model.dart';
import 'package:archilink/features/settings/domain/entity/send_support_message_response_entity.dart';

class SendSupportMessageResponseModel extends SendSupportMessageResponseEntity {
  const SendSupportMessageResponseModel({
    required super.id,
    required super.chatId,
    required super.content,
    required super.sentAt,
    super.editedAt,
    required super.sender,
  });

  factory SendSupportMessageResponseModel.fromJson(Map<String, dynamic> json) {
    // If the input JSON is the full response wrapper containing a "data" object,
    // we extract the data object. Otherwise, we assume the input JSON is the data object itself.
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return SendSupportMessageResponseModel(
      id: data['id'] as int,
      chatId: data['chat_id'] as int,
      content: data['content'] as String,
      sentAt: DateTime.parse(data['sent_at'] as String),
      editedAt: data['edited_at'] != null
          ? DateTime.parse(data['edited_at'] as String)
          : null,
      sender: SenderModel.fromJson(data['sender'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'content': content,
      'sent_at': sentAt.toIso8601String(),
      'edited_at': editedAt?.toIso8601String(),
      'sender': {
        'id': sender.id,
        'name': sender.name,
        'username': sender.username,
        'user_avatar': sender.userAvatar,
        'country': sender.country,
        'city': sender.city,
      },
    };
  }
}
