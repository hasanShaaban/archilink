import 'package:archilink/features/Home/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Home/domain/entity/post_entity.dart';

class GlobalFeedEntity {
  final List<PostEntity> posts;
  final PaginationEntity pagination;

  const GlobalFeedEntity({
    required this.posts,
    required this.pagination,
  });
}