import 'package:archilink/features/Chat/data/model/chat_model/message_model.dart';
import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_messages_entity.dart';

class CustomerSupportMessagesModel extends CustomerSupportMessagesEntity {
  const CustomerSupportMessagesModel({
    required super.messages,
    required super.pagination,
  });

  factory CustomerSupportMessagesModel.fromJson(Map<String, dynamic> json) {
    // If the input JSON is the full response wrapper containing a "data" object,
    // we extract the data object. Otherwise, we assume the input JSON is the data object itself.
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawMessages = (data['messages'] as List<dynamic>? ?? const []);

    return CustomerSupportMessagesModel(
      messages: rawMessages
          .whereType<Map<String, dynamic>>()
          .map((item) => MessageModel.fromJson(item))
          .toList(),
      pagination: PaginationModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ).toEntity(),
    );
  }
}
