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

  @override
  List<Object> get props => [postId, liked, likesCont];
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
  List<Object> get props => [commentId];
}

class AddComment extends PostDetailsEvent {
  final String body;
  final int? parentId;

  const AddComment({required this.body, this.parentId});

  @override
  List<Object> get props => [body, parentId ?? -1];
}

class DeleteComment extends PostDetailsEvent {
  final int commentId;
  final int? parentId;

  const DeleteComment({required this.commentId, this.parentId});

  @override
  List<Object> get props => [commentId, parentId ?? -1];
}

