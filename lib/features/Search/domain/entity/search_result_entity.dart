import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Search/domain/entity/store_entity.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';

class SearchResultEntity {
  final List<PostEntity> posts;
  final PaginationEntity postsPagination;
  final List<UserEntity> users;
  final PaginationEntity usersPagination;
  final List<StoreEntity> stores;
  final PaginationEntity storesPagination;

  const SearchResultEntity({
    required this.posts,
    required this.postsPagination,
    required this.users,
    required this.usersPagination,
    required this.stores,
    required this.storesPagination,
  });
}