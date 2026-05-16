import 'package:archilink/features/Post/data/models/media_item_model.dart';
import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Post/data/models/post_owner_model.dart';
import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';

class CommentsHistoryModel extends CommentsHistoryEntity {
  const CommentsHistoryModel({
    required super.comments,
    required super.pagination,
  });

  factory CommentsHistoryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final rawComments = (data['comments'] as List<dynamic>? ?? const []);

    return CommentsHistoryModel(
      comments: rawComments
          .whereType<Map<String, dynamic>>()
          .map((item) => CommentHistoryItemModel.fromJson(item).toEntity())
          .toList(),
      pagination: PaginationModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ).toEntity(),
    );
  }
}

class CommentHistoryItemModel {
  final int id;
  final int? parentId;
  final String body;
  final bool likedByMe;
  final String createdAt;
  final PostOwnerModel owner;
  final CommentHistoryPostSummaryModel post;

  const CommentHistoryItemModel({
    required this.id,
    required this.parentId,
    required this.body,
    required this.likedByMe,
    required this.createdAt,
    required this.owner,
    required this.post,
  });

  factory CommentHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return CommentHistoryItemModel(
      id: json['id'] as int,
      parentId: json['parent_id'] as int?,
      body: json['body'] as String? ?? '',
      likedByMe: json['liked_by_me'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      owner: PostOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      post: CommentHistoryPostSummaryModel.fromJson(
        json['post'] as Map<String, dynamic>,
      ),
    );
  }

  CommentHistoryItemEntity toEntity() {
    return CommentHistoryItemEntity(
      id: id,
      parentId: parentId,
      body: body,
      likedByMe: likedByMe,
      createdAt: createdAt,
      owner: owner.toEntity(),
      post: post.toEntity(),
    );
  }
}

class CommentHistoryPostSummaryModel {
  final int id;
  final PostOwnerModel owner;
  final String body;
  final List<MediaItemModel> mediaItems;

  const CommentHistoryPostSummaryModel({
    required this.id,
    required this.owner,
    required this.body,
    required this.mediaItems,
  });

  factory CommentHistoryPostSummaryModel.fromJson(Map<String, dynamic> json) {
    return CommentHistoryPostSummaryModel(
      id: json['id'] as int,
      owner: PostOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      body: json['body'] as String? ?? '',
      mediaItems: (json['media_items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(MediaItemModel.fromJson)
          .toList(),
    );
  }

  CommentHistoryPostSummaryEntity toEntity() {
    return CommentHistoryPostSummaryEntity(
      id: id,
      owner: owner.toEntity(),
      body: body,
      mediaItems: mediaItems.map((e) => e.toEntity()).toList(),
    );
  }
}
