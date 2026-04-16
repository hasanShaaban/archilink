import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/entity/messages_reponse_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';

class ChatRepoImpl extends ChatRepo {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, MessagesResponseEntity>> fetchMessages({
    required int conversationId,
    required int page,
  }) async {
    try {
      final result = await remoteDataSource.fetchMessages(
        conversationId: conversationId,
        page: page,
      );
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
