part of 'post_like_cubit.dart';

class PostLikeState extends Equatable {
  final bool liked;
  final int likeCount;
  final int postId;

  const PostLikeState({
    required this.liked,
    required this.likeCount,
    required this.postId,
  });

  @override
  List<Object> get props => [liked, likeCount, postId];
}
