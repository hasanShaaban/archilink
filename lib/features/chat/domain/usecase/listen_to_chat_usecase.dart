import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';

class ListenToChatUsecase {
  final ChatWebsocketRepo _repo;

  ListenToChatUsecase(this._repo);

  Stream<ChatSocketEvent> call(int conversationId) {
    return _repo.subscribeToChannle(conversationId);
  }
}
