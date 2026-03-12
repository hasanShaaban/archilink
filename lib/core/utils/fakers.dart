import 'package:archilink/features/Home/domain/entity/feed_item.dart';
import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/domain/entity/post_owner_entity.dart';
import 'package:archilink/features/Post/domain/entity/tag_entity.dart';

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
