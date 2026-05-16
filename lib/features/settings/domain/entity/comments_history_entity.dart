import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';

class CommentsHistoryEntity {
  final List<CommentHistoryItemEntity> comments;
  final PaginationEntity pagination;

  const CommentsHistoryEntity({
    required this.comments,
    required this.pagination,
  });
}

class CommentHistoryItemEntity {
  final int id;
  final int? parentId;
  final String body;
  final bool likedByMe;
  final String createdAt;
  final PostOwnerEntity owner;
  final CommentHistoryPostSummaryEntity post;

  const CommentHistoryItemEntity({
    required this.id,
    required this.parentId,
    required this.body,
    required this.likedByMe,
    required this.createdAt,
    required this.owner,
    required this.post,
  });
}

class CommentHistoryPostSummaryEntity {
  final int id;
  final PostOwnerEntity owner;
  final String body;
  final List<MediaItemEntity> mediaItems;

  const CommentHistoryPostSummaryEntity({
    required this.id,
    required this.owner,
    required this.body,
    required this.mediaItems,
  });
}
