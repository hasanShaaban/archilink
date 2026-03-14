import 'package:archilink/features/Post_Details/domain/entity/comment_owner_entity.dart';

class CommentEntity {
  final int id;
  final String body;
  final String createdAt;
  final int? parentId;
  final int likesCount;
  final int repliesCount;
  final bool likedByMe;
  final CommentOwnerEntity owner;

  const CommentEntity({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
    this.parentId,
    required this.likesCount,
    required this.repliesCount,
    required this.likedByMe,
  });

  CommentEntity copyWith({
    int? id,
    String? body,
    String? createdAt,
    int? parentId,
    int? likesCount,
    int? repliesCount,
    bool? likedByMe,
    CommentOwnerEntity? owner,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      parentId: parentId ?? this.parentId,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      likedByMe: likedByMe ?? this.likedByMe,
      owner: owner ?? this.owner,
    );
  }
}