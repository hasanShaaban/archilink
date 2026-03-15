part of 'post_details_bloc.dart';

sealed class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();

  @override
  List<Object> get props => [];
}

class ToggleLikePost extends PostDetailsEvent {}

class LoadComments extends PostDetailsEvent {}

class LoadMoreComments extends PostDetailsEvent {}

class SyncPostLike extends PostDetailsEvent {
  final int postId;
  final bool liked;
  final int likesCont;

  const SyncPostLike({
    required this.postId,
    required this.liked,
    required this.likesCont,
  });
}

class LoadReplies extends PostDetailsEvent {
  final int commentId;
  const LoadReplies(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class LoadMoreReplies extends PostDetailsEvent {
  final int commentId;

  const LoadMoreReplies(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class RefreshPostDetails extends PostDetailsEvent {}

class ToggleCommentLike extends PostDetailsEvent {
  final int commentId;

  const ToggleCommentLike(this.commentId);

  @override
  List<Object> get props => [commentsTree];
}
