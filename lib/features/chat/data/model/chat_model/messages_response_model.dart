import 'package:archilink/features/Chat/data/model/chat_model/message_model.dart';
import 'package:archilink/features/Chat/data/model/chat_model/messages_pagination_model.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/messages_reponse_entity.dart';

class MessagesResponseModel extends MessagesResponseEntity {
  const MessagesResponseModel({
    required super.messages,
    required super.pagination,
  });

  // Parses the full API response:
  // { "status": "success", "message": { "messages": [...], "pagination": {...} } }
  factory MessagesResponseModel.fromJson(Map<String, dynamic> json) {
    final body = json['data'] as Map<String, dynamic>;

    return MessagesResponseModel(
      messages: (body['messages'] as List)
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      pagination: MessagesPaginationModel.fromJson(
        body['pagination'] as Map<String, dynamic>,
      ),
    );
  }
}