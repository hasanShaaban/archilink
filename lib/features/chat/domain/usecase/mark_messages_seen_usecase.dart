import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';

/// Marks messages as seen up to [lastSeenMessageId] for [conversationId].
///
/// Should be called when the user scrolls an incoming message into view.
class MarkMessagesSeenUsecase {
  final ChatRepo _repo;

  MarkMessagesSeenUsecase(this._repo);

  Future<Either<Failure, void>> call({
    required int conversationId,
    required int lastSeenMessageId,
  }) {
    return _repo.markMessagesSeen(
      conversationId: conversationId,
      lastSeenMessageId: lastSeenMessageId,
    );
  }
}
