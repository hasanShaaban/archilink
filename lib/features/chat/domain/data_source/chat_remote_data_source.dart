import 'package:archilink/features/Chat/domain/entity/messages_reponse_entity.dart';

abstract class ChatRemoteDataSource {
  Future<MessagesResponseEntity> fetchMessages({
    required int conversationId,
    required int page,
  });
}
