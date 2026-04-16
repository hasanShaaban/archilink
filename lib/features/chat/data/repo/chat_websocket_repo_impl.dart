import 'package:archilink/features/Chat/domain/data_source/chat_websocket_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';

class ChatWebsocketRepoImpl extends ChatWebsocketRepo {
  final ChatWebsocketRemoteDataSource remoteDataSource;

  ChatWebsocketRepoImpl(this.remoteDataSource);
  @override
  Stream<ChatSocketEvent> subscribeToChannle(int conversationId) {
    return remoteDataSource.subscribeToChannel(conversationId);
  }

  @override
  Future<void> unsubscribeFromChannle(int conversationId) {
    return remoteDataSource.unsubscribeFromChannel(conversationId);
  }
}
