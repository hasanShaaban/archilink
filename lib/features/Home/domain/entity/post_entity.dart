import 'package:archilink/features/Home/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Home/domain/entity/tag_entity.dart';

class PostEntity {
  final int id;
  final String body;
  final DateTime createdAt;
  final PostOwnerEntity owner;
  final List<TagEntity> tags;
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
  });
}
