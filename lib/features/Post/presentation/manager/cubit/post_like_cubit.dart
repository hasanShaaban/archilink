import 'dart:developer';

import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_like_state.dart';

class PostLikeCubit extends Cubit<PostLikeState?> {
  final PostRepo repo;
  PostLikeCubit(this.repo) : super(null);

  Future<void> toggleLike({
    required int postId,
    required bool liked,
    required int likeCount,
  }) async {
    final optimisticLiked = !liked;
    final optimisticCount = optimisticLiked ? likeCount + 1 : likeCount - 1;

    emit(
      PostLikeState(
        liked: optimisticLiked,
        likeCount: optimisticCount,
        postId: postId,
      ),
    );

    final result = await repo.togglePostLike(postId: postId);

    result.fold((failure) {
      log('failure');
    }, (serverLiked) {
      log('emit the state of : $serverLiked');
      emit(
        PostLikeState(
          liked: serverLiked,
          likeCount: optimisticCount,
          postId: postId,
        ),
      );
    });
  }
}
