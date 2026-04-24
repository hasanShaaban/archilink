import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Search/data/model/search_result_model.dart';
import 'package:archilink/features/Search/domain/data_source/search_remote_data_source.dart';
import 'package:archilink/features/Search/domain/entity/search_result_entity.dart';
import 'package:dio/dio.dart';

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final ApiService apiService;

  SearchRemoteDataSourceImpl(this.apiService);
  @override
  Future<SearchResultEntity> searchResult({
    required String q,
    required int postsPage,
    required int usersPage,
    List<String>? tags,
    String? city,
    String? country,
    String? accountType,
    List<String>? services,
  }) async {
    try {
      final body = <String, dynamic>{};

      body['q'] = q;
      final user = <String, dynamic>{};
      if (accountType != null) user['account_type'] = accountType;
      if (city != null) user['city'] = city;
      if (country != null) user['country'] = country;
      if (services != null && services.isNotEmpty) user['services'] = services;
      if (user.isNotEmpty) body['user'] = user;
      final post = <String, dynamic>{};
      if (tags != null && tags.isNotEmpty) post['tags'] = tags;
      if (post.isNotEmpty) body['post'] = post;

      final response = await apiService.post(
        'home/search?posts_page=$postsPage&users_page=$usersPage',
        body: body,
      );

      final data = response.data;
      if (data == null) {
        throw ServerException(message: "Invalid data response");
      }
      return SearchResultModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
