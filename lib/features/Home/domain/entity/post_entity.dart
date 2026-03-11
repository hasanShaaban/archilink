import 'package:archilink/features/Home/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Home/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Home/domain/entity/tag_entity.dart';

class PostEntity {
  final int id;
  final String body;
  final DateTime createdAt;
  final PostOwnerEntity owner;
  final List<TagEntity> tags;
  final List<MediaItemEntity> mediaItems;
  final int likesCount;
  final int commentsCount;
  final bool likedByMe;
  const PostEntity({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.tags,
    required this.likesCount,
    required this.commentsCount,
    required this.likedByMe,
    required this.mediaItems,
  });

  PostEntity copyWith({
    int? id,
    String? body,
    DateTime? createdAt,
    PostOwnerEntity? owner,
    List<TagEntity>? tags,
    int? likesCount,
    int? commentsCount,
    bool? likedByMe,
    List<MediaItemEntity>? mediaItems
  }) {
    return PostEntity(
      id: id ?? this.id,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      owner: owner ?? this.owner,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedByMe: likedByMe ?? this.likedByMe,
      mediaItems: mediaItems ?? this.mediaItems
    );
  }
}
