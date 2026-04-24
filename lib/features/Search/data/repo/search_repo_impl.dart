import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Search/domain/data_source/search_remote_data_source.dart';
import 'package:archilink/features/Search/domain/entity/search_result_entity.dart';
import 'package:archilink/features/Search/domain/repo/search_repo.dart';
import 'package:dartz/dartz.dart';

class SearchRepoImpl extends SearchRepo {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, SearchResultEntity>> searchResult({
    required String q,
    required int postsPage,
    required int usersPage,
    String? accountType,
    String? country,
    String? city,
    List<String>? services,
    List<String>? tags,
  }) async {
    try {
      final result = await remoteDataSource.searchResult(
        q: q,
        postsPage: postsPage,
        usersPage: usersPage,
        accountType: accountType,
        city: city,
        country: country,
        tags: tags,
        services: services,
      );
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
