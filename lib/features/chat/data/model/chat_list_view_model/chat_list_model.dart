import 'package:archilink/features/Chat/data/model/chat_list_view_model/chat_model.dart';
import 'package:archilink/features/Chat/data/model/chat_list_view_model/pagination_model.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_list_entity.dart';

class ChatListModel extends ChatListEntity {
  const ChatListModel({
    super.status,
    super.message,
    required super.chats,
    required super.pagination,
  });

  /// Parses directly from the full API response:
  /// { "status": "...", "message": "...", "data": { "chats": [...], "pagination": {...} } }
  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? {};

    return ChatListModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      chats: (data['chats'] as List<dynamic>?)
              ?.map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: data['pagination'] != null
          ? PaginationModel.fromJson(
              data['pagination'] as Map<String, dynamic>,
            )
          : const PaginationModel(
              currentPage: 1,
              perPage: 20,
              total: 0,
              lastPage: 1,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (message != null) 'message': message,
      'data': {
        'chats': chats.map((e) => (e as ChatModel).toJson()).toList(),
        'pagination': (pagination as PaginationModel).toJson(),
      },
    };
  }
}

