import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';

class CollectionPostsEntity {
  final List<CollectionItemEntity> items;

  const CollectionPostsEntity({
    required this.items,
  });
}

class CollectionItemEntity {
  final int id;
  final int collectibleId;
  final String collectibleType;
  final CollectiblePostEntity collectible;

  const CollectionItemEntity({
    required this.id,
    required this.collectibleId,
    required this.collectibleType,
    required this.collectible,
  });
}

class CollectiblePostEntity {
  final int id;
  final String body;
  final DateTime createdAt;
  final PostOwnerEntity owner;
  final List<MediaItemEntity> mediaItems;
  final bool likedByMe;
  final DateTime? deletedAt;

  const CollectiblePostEntity({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.mediaItems,
    required this.likedByMe,
    this.deletedAt,
  });

  /// Converts this collectible post to a [PostEntity] for reuse in post widgets.
  PostEntity toPostEntity() {
    return PostEntity(
      id: id,
      body: body,
      createdAt: createdAt,
      owner: owner,
      tags: const [],
      likesCount: 0,
      commentsCount: 0,
      likedByMe: likedByMe,
      mediaItems: mediaItems,
    );
  }
}
