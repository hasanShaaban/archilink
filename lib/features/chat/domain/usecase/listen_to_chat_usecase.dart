import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';

class ListenToChatUsecase {
  final ChatRepo _repo;

  ListenToChatUsecase(this._repo);

  Stream<ChatSocketEvent> call(int conversationId) {
    return _repo.subscribeToChannle(conversationId);
  }
}
