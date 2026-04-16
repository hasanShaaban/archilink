import 'package:archilink/features/Chat/domain/data_source/chat_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepoImpl(this.remoteDataSource);
  @override
  Stream<ChatSocketEvent> subscribeToChannle(int conversationId) {
    return remoteDataSource.subscribeToChannel(conversationId);
  }

  @override
  Future<void> unsubscribeFromChannle(int conversationId) {
    return remoteDataSource.unsubscribeFromChannel(conversationId);
  }
}
