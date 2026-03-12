part of 'post_details_bloc.dart';

sealed class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();

  @override
  List<Object> get props => [];
}
class ToggleLikePost extends PostDetailsEvent{}
class SyncPostLike extends PostDetailsEvent{
  final int postId;
  final bool liked;
  final int likesCont;

  const SyncPostLike({required this.postId, required this.liked, required this.likesCont});

}