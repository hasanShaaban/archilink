import 'package:archilink/features/Post/data/models/media_item_model.dart';
import 'package:archilink/features/Post/data/models/post_owner_model.dart';
import 'package:archilink/features/settings/domain/entity/collection_posts_entity.dart';

class CollectionPostsModel extends CollectionPostsEntity {
  const CollectionPostsModel({
    required super.items,
  });

  factory CollectionPostsModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<dynamic> list = rawData is List<dynamic>
        ? rawData
        : (json is List<dynamic> ? json as List<dynamic> : const []);

    return CollectionPostsModel(
      items: list
          .whereType<Map<String, dynamic>>()
          .map((item) => CollectionItemModel.fromJson(item).toEntity())
          .toList(),
    );
  }

  static List<CollectionItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .whereType<Map<String, dynamic>>()
        .map(CollectionItemModel.fromJson)
        .toList();
  }
}

class CollectionItemModel {
  final int id;
  final int collectibleId;
  final String collectibleType;
  final CollectiblePostModel collectible;

  const CollectionItemModel({
    required this.id,
    required this.collectibleId,
    required this.collectibleType,
    required this.collectible,
  });

  factory CollectionItemModel.fromJson(Map<String, dynamic> json) {
    return CollectionItemModel(
      id: (json['id'] as num).toInt(),
      collectibleId: (json['collectible_id'] as num).toInt(),
      collectibleType: json['collectible_type'] as String? ?? 'post',
      collectible: CollectiblePostModel.fromJson(
        json['collectible'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collectible_id': collectibleId,
      'collectible_type': collectibleType,
      'collectible': collectible.toJson(),
    };
  }

  CollectionItemEntity toEntity() {
    return CollectionItemEntity(
      id: id,
      collectibleId: collectibleId,
      collectibleType: collectibleType,
      collectible: collectible.toEntity(),
    );
  }
}

class CollectiblePostModel {
  final int id;
  final String body;
  final DateTime createdAt;
  final PostOwnerModel owner;
  final List<MediaItemModel> mediaItems;
  final bool likedByMe;
  final DateTime? deletedAt;

  const CollectiblePostModel({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.mediaItems,
    required this.likedByMe,
    this.deletedAt,
  });

  factory CollectiblePostModel.fromJson(Map<String, dynamic> json) {
    final rawMedia = json['media_items'];
    final List<MediaItemModel> mediaList = rawMedia is List<dynamic>
        ? rawMedia
            .whereType<Map<String, dynamic>>()
            .map(MediaItemModel.fromJson)
            .toList()
        : const [];

    return CollectiblePostModel(
      id: (json['id'] as num).toInt(),
      body: json['body'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      owner: PostOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      mediaItems: mediaList,
      likedByMe: json['liked_by_me'] as bool? ?? false,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'owner': {
        'id': owner.id,
        'name': owner.name,
        'username': owner.username,
        'user_avatar': owner.profilePictureUrl,
        'city': owner.city,
        'country': owner.country,
      },
      'media_items': mediaItems.map((e) => e.toJson()).toList(),
      'liked_by_me': likedByMe,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  CollectiblePostEntity toEntity() {
    return CollectiblePostEntity(
      id: id,
      body: body,
      createdAt: createdAt,
      owner: owner.toEntity(),
      mediaItems: mediaItems.map((e) => e.toEntity()).toList(),
      likedByMe: likedByMe,
      deletedAt: deletedAt,
    );
  }
}
