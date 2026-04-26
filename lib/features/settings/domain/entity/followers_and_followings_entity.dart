
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Search/domain/entity/user_entity.dart';

class FollowersAndFollowingsEntity {
  final List<UserEntity> users;
  final PaginationEntity pagination;

  const FollowersAndFollowingsEntity({required this.users, required this.pagination});
}
