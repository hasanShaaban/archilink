import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';

abstract class ChatRemoteDataSource {
  Stream<ChatSocketEvent> subscribeToChannel(int conversationId);
  Future<void> unsubscribeFromChannel(int conversationId);
}
