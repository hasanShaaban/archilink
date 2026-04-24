import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Search/domain/entity/search_result_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SearchRepo {
  Future<Either<Failure, SearchResultEntity>> searchResult({
    required String q,
    required int postsPage,
    required int usersPage,
    String? accountType,
    String? country,
    String? city,
    List<String>? services,
    List<String>? tags,
  });
}
