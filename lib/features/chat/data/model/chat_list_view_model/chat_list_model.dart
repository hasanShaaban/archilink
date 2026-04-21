import 'package:archilink/features/Chat/data/model/chat_list_view_model/chat_model.dart';
import 'package:archilink/features/Chat/data/model/chat_list_view_model/pagination_model.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_list_entity.dart';

class ChatListModel extends ChatListEntity {
  const ChatListModel({required super.chats, required super.pagination});

  /// Parses directly from the full API response:
  /// { "status": "...", "message": "...", "data": { "chats": [...], "pagination": {...} } }
  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return ChatListModel(
      chats: (data['chats'] as List<dynamic>)
          .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'chats': chats.map((e) => (e as ChatModel).toJson()).toList(),
        'pagination': (pagination as PaginationModel).toJson(),
      },
    };
  }
}
