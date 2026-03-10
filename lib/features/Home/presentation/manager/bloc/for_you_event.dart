part of 'for_you_bloc.dart';

sealed class ForYouEvent extends Equatable {
  const ForYouEvent();

  @override
  List<Object> get props => [];
}

class LoadInitital extends ForYouEvent{}
class LoadMore extends ForYouEvent{}
class RefreshFeed extends ForYouEvent{}
class UpdatePostLike extends ForYouEvent{
  final int postId;
  final bool liked;
  final int likesCount;

  const UpdatePostLike(this.postId, this.liked, this.likesCount);
  
}