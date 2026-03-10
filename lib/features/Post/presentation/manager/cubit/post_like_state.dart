part of 'post_like_cubit.dart';

class PostLikeState extends Equatable {
  final bool liked;
  final int likeCount;
  const PostLikeState({required this.liked, required this.likeCount});

  PostLikeState copyWith({bool? liked, int? likeCount}) {
    return PostLikeState(
      liked: liked ?? this.liked,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  @override
  List<Object> get props => [];
}
