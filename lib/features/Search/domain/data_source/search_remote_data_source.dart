import 'package:archilink/features/Search/domain/entity/search_result_entity.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultEntity> searchResult({
    required String q,
    List<String>? tags,
    String? city,
    String? country,
    String? accountType,
    List<String>? services,
    required int postsPage,
    required int  usersPage
  });
}
