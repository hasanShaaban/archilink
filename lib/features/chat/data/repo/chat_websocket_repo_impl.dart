import 'package:archilink/features/Chat/domain/data_source/chat_websocket_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';

class ChatWebsocketRepoImpl extends ChatWebsocketRepo {
  final ChatWebsocketRemoteDataSource remoteDataSource;

  ChatWebsocketRepoImpl(this.remoteDataSource);
  @override
  Stream<ChatSocketEvent> subscribeToChannle(int userId) {
    return remoteDataSource.subscribeToChannel(userId);
  }

  @override
  Future<void> unsubscribeFromChannle(int userId) {
    return remoteDataSource.unsubscribeFromChannel(userId);
  }
}
