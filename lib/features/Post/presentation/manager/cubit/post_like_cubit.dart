import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_like_state.dart';

class PostLikeCubit extends Cubit<PostLikeState> {
  final PostRepo repo;
  final int postId;
  PostLikeCubit(
    this.repo, {
    required this.postId,
    required bool liked,
    required int likeCount,
  }) : super(PostLikeState(liked: liked, likeCount: likeCount));

  Future<void> toggleLike() async {
    final previousState = state;

    final newLiked = !state.liked;
    final newCount = newLiked ? state.likeCount + 1 : state.likeCount - 1;

    emit(state.copyWith(liked: newLiked, likeCount: newCount));
    final result = await repo.togglePostLike(postId: postId);
    result.fold(
      (failure) => emit(previousState),
      (liked) => emit(state.copyWith(liked: liked)),
    );
  }
}
