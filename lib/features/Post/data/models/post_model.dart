import 'package:archilink/features/Post/data/models/media_item_model.dart';
import 'package:archilink/features/Post/data/models/post_owner_model.dart';
import 'package:archilink/features/Post/data/models/tag_model.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';

class PostModel {
  final int id;
  final String body;
  final DateTime createdAt;
  final PostOwnerModel owner;
  final List<TagModel> tags;
  final List<MediaItemModel> mediaItems;
  final int likesCount;
  final int commentsCount;
  final bool likedByMe;

  PostModel({
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

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      owner: PostOwnerModel.fromJson(json['owner']),
      tags: (json['tags'] as List).map((e) => TagModel.fromJson(e)).toList(),
      mediaItems: (json['media_items'] as List)
          .map((e) => MediaItemModel.fromJson(e))
          .toList(),
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      likedByMe: json['liked_by_me'],
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      body: body,
      createdAt: createdAt,
      owner: owner.toEntity(),
      tags: tags.map((e) => e.toEntity()).toList(),
      mediaItems: mediaItems.map((e) => e.toEntity()).toList(),
      likesCount: likesCount,
      commentsCount: commentsCount,
      likedByMe: likedByMe,
    );
  }
}
