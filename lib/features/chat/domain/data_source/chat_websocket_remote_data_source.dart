import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';

abstract class ChatWebsocketRemoteDataSource {
  /// Connects to [currentUserId]'s private channel and returns a single
  /// broadcast stream of all chat-related socket events for that user.
  /// Consumers filter by chatId themselves.
  Stream<ChatSocketEvent> connect(int currentUserId);

  Future<void> disconnect();
}
