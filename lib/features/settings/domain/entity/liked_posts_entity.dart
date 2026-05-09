import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';

class LikedPostsEntity {
  final List<LikedPostItemEntity> likes;
  final PaginationEntity pagination;

  const LikedPostsEntity({
    required this.likes,
    required this.pagination,
  });
}

class LikedPostItemEntity {
  final int entityId;
  final String entityType;
  final LikedPostSummaryEntity entity;

  const LikedPostItemEntity({
    required this.entityId,
    required this.entityType,
    required this.entity,
  });
}

class LikedPostSummaryEntity {
  final int id;
  final PostOwnerEntity owner;
  final String body;
  final List<MediaItemEntity> mediaItems;

  const LikedPostSummaryEntity({
    required this.id,
    required this.owner,
    required this.body,
    required this.mediaItems,
  });
}
