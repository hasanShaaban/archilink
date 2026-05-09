import 'package:archilink/features/Post/data/models/media_item_model.dart';
import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Post/data/models/post_owner_model.dart';
import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';

class LikedPostsModel extends LikedPostsEntity {
  const LikedPostsModel({
    required super.likes,
    required super.pagination,
  });

  factory LikedPostsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final rawLikes = (data['likes'] as List<dynamic>? ?? const []);

    return LikedPostsModel(
      likes: rawLikes
          .whereType<Map<String, dynamic>>()
          .where((item) => (item['entity_type'] as String?) == 'post')
          .map((item) => LikedPostItemModel.fromJson(item).toEntity())
          .toList(),
      pagination: PaginationModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ).toEntity(),
    );
  }
}

class LikedPostItemModel {
  final int entityId;
  final String entityType;
  final LikedPostSummaryModel entity;

  const LikedPostItemModel({
    required this.entityId,
    required this.entityType,
    required this.entity,
  });

  factory LikedPostItemModel.fromJson(Map<String, dynamic> json) {
    return LikedPostItemModel(
      entityId: json['entity_id'] as int,
      entityType: json['entity_type'] as String,
      entity: LikedPostSummaryModel.fromJson(
        json['entity'] as Map<String, dynamic>,
      ),
    );
  }

  LikedPostItemEntity toEntity() {
    return LikedPostItemEntity(
      entityId: entityId,
      entityType: entityType,
      entity: entity.toEntity(),
    );
  }
}

class LikedPostSummaryModel {
  final int id;
  final PostOwnerModel owner;
  final String body;
  final List<MediaItemModel> mediaItems;

  const LikedPostSummaryModel({
    required this.id,
    required this.owner,
    required this.body,
    required this.mediaItems,
  });

  factory LikedPostSummaryModel.fromJson(Map<String, dynamic> json) {
    return LikedPostSummaryModel(
      id: json['id'] as int,
      owner: PostOwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
      body: json['body'] as String,
      mediaItems: (json['media_items'] as List<dynamic>).whereType<Map<String, dynamic>>()
          .map(MediaItemModel.fromJson)
          .toList() ,
    );
  }

  LikedPostSummaryEntity toEntity() {
    return LikedPostSummaryEntity(
      id: id,
      owner: owner.toEntity(),
      body: body,
      mediaItems: mediaItems.map((e) => e.toEntity()).toList(),
    );
  }
}
