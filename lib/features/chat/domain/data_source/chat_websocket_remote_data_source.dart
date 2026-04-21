import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/messages_reponse_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';

abstract class ChatWebsocketRemoteDataSource {
  Stream<ChatSocketEvent> subscribeToChannel(int conversationId);
  Future<void> unsubscribeFromChannel(int conversationId);
  
}
