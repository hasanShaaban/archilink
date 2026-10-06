import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Chat/data/model/chat_list_view_model/chat_list_model.dart';
import 'package:archilink/features/Chat/data/model/chat_model/message_model.dart';
import 'package:archilink/features/Chat/data/model/chat_model/messages_response_model.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/messages_reponse_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_list_entity.dart';
import 'package:dio/dio.dart';

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final ApiService apiService;

  ChatRemoteDataSourceImpl(this.apiService);

  @override
  Future<MessagesResponseEntity> fetchMessages({
    required int conversationId,
    required int page,
  }) async {
    try {
      final response = await apiService.get(
        'chats/$conversationId/messages?page=$page',
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Invalid data response');
      }
      return MessagesResponseModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<ChatListEntity> getChats() async {
    try {
      final response = await apiService.get('chats/my-chats');
      final data = response.data;
      if (data == null) {
        throw Exception('Invalid data response');
      }
      return ChatListModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<MessageEntity> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    try {
      final response = await apiService.post(
        'chats/$conversationId',
        body: {'content': content},
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Invalid data response');
      }
      final body = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data as Map<String, dynamic>;
      return MessageModel.fromJson(body);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<void> deleteMessage({
    required int conversationId,
    required int messageId,
  }) async {
    try {
      await apiService.delete(
        'chats/$conversationId/messages/$messageId',
      );
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<void> reactMessage({
    required int conversationId,
    required int messageId,
    required String reaction,
  }) async {
    try {
      await apiService.post(
        'chats/$conversationId/react',
        body: {
          'message_id': messageId.toString(),
          'reaction': reaction,
        },
      );
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<void> removeReaction({
    required int conversationId,
    required int messageId,
  }) async {
    try {
      await apiService.delete(
        'chats/$conversationId/react',
        body: {
          'message_id': messageId.toString(),
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        // Fallback to POST if server endpoint does not allow DELETE
        try {
          await apiService.post(
            'chats/$conversationId/react',
            body: {
              'message_id': messageId.toString(),
            },
          );
          return;
        } on DioException catch (postError) {
          throw AppException.handelDioException(postError);
        }
      }
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<void> markMessagesSeen({
    required int conversationId,
    required int lastSeenMessageId,
  }) async {
    try {
      await apiService.post(
        'chats/$conversationId/seen',
        body: {'last_seen_message_id': lastSeenMessageId},
      );
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<void> pingPresence({required int conversationId}) async {
    try {
      await apiService.post('chats/$conversationId/presence/ping');
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<void> leavePresence({required int conversationId}) async {
    try {
      await apiService.post('chats/$conversationId/presence/leave');
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
