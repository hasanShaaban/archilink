

import 'package:archilink/features/Post/domain/entity/post_entity.dart';

abstract class FeedItem {
  const FeedItem();
}

class PostItem extends FeedItem{
  final PostEntity post;

  const PostItem(this.post);
}

