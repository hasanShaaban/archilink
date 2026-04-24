import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Search/data/model/store_model.dart';
import 'package:archilink/features/Search/data/model/user_model.dart';
import 'package:archilink/features/Search/domain/entity/search_result_entity.dart';

import '../../../Post/data/models/post_model.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.posts,
    required super.postsPagination,
    required super.users,
    required super.usersPagination,
    required super.stores,
    required super.storesPagination,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final postsResults = data['posts_results'] as Map<String, dynamic>;
    final usersResults = data['users_results'] as Map<String, dynamic>;
    final storesResults = data['stores_results'] as Map<String, dynamic>;

    return SearchResultModel(
      posts: (postsResults['posts'] as List<dynamic>)
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList(),
      postsPagination: PaginationModel.fromJson(
        postsResults['pagination'] as Map<String, dynamic>,
      ).toEntity(),
      users: (usersResults['users'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      usersPagination: PaginationModel.fromJson(
        usersResults['pagination'] as Map<String, dynamic>,
      ).toEntity(),
      stores: (storesResults['stores'] as List<dynamic>)
          .map((e) => StoreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      storesPagination: PaginationModel.fromJson(
        storesResults['pagination'] as Map<String, dynamic>,
      ).toEntity(),
    );
  }
}
