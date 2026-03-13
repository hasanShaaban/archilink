import 'package:archilink/features/Home/domain/entity/feed_item.dart';
import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Post/domain/entity/tag_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_owner_entity.dart';

PostEntity fakePostEntity({int id = 0}) {
  return PostEntity(
    id: id,
    body: 'Loading post content...',
    createdAt: DateTime.now(),
    owner: const PostOwnerEntity(
      id: 0,
      name: 'Loading User',
      username: 'loading_user',
      profilePictureUrl: null,
    ),
    tags: const <TagEntity>[],
    likesCount: 0,
    commentsCount: 0,
    likedByMe: false,
    mediaItems: const <MediaItemEntity>[],
  );
}

List<FeedItem> fakeFeedItems({int count = 5}) {
  return List<FeedItem>.generate(
    count,
    (index) => PostItem(fakePostEntity(id: index)),
  );
}

CommentOwnerEntity fakeCommentOwnerEntity({int id = 0}) {
  return CommentOwnerEntity(
    id: id,
    name: 'Loading User $id',
    username: 'loading_user_$id',
    profilePictureUrl: null,
  );
}

CommentEntity fakeCommentEntity({int id = 0, int? parentId}) {
  return CommentEntity(
    id: id,
    body: 'Loading comment content...',
    createdAt: DateTime.now().toIso8601String(),
    owner: fakeCommentOwnerEntity(id: id),
    parentId: parentId,
    likesCount: 0,
    repliesCount: 0,
    likedByMe: false,
  );
}

List<CommentEntity> fakeCommentEntities({int count = 5}) {
  return List<CommentEntity>.generate(
    count,
    (index) => fakeCommentEntity(id: index),
  );
}
