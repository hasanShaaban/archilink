import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';

class PostsEntity {
  final List<PostEntity> posts;
  final PaginationEntity pagination;

  const PostsEntity({
    required this.posts,
    required this.pagination,
  });
}