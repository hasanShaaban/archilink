import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Chat/data/model/messages_response_model.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/entity/messages_reponse_entity.dart';
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
}
