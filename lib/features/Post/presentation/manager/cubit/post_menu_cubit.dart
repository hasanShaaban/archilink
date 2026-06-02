import 'dart:developer';

import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/Post/presentation/view/post.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_menu_state.dart';

class PostMenuCubit extends Cubit<PostMenuState> {
  final PostRepo repo;
  final Set<int> hiddenPostIds = {};
  final Set<int> closedPostIds = {};

  PostMenuCubit(this.repo) : super(const PostMenuInitial());

  /// Mark interest in a post.
  Future<void> interestPost({required int postId}) async {
    emit(PostMenuLoading(action: PostMenuAction.interest, postId: postId));

    final result = await repo.interestPost(postId: postId);

    result.fold(
      (failure) {
        log('PostMenuCubit: interest failed – $failure');
        emit(PostMenuFailure(
          action: PostMenuAction.interest,
          postId: postId,
          message: failure.message,
        ));
      },
      (success) {
        log('PostMenuCubit: interest success – $success');
        emit(PostMenuSuccess(
          action: PostMenuAction.interest,
          postId: postId,
          message: 'Interest registered successfully',
        ));
      },
    );
  }

  /// Hide a post.
  Future<void> hidePost({required int postId}) async {
    emit(PostMenuLoading(action: PostMenuAction.hide, postId: postId));

    final result = await repo.hidePost(postId: postId);

    result.fold(
      (failure) {
        log('PostMenuCubit: hide failed – $failure');
        emit(PostMenuFailure(
          action: PostMenuAction.hide,
          postId: postId,
          message: failure.message,
        ));
      },
      (success) {
        log('PostMenuCubit: hide success – $success');
        hiddenPostIds.add(postId);
        emit(PostMenuSuccess(
          action: PostMenuAction.hide,
          postId: postId,
          message: 'Post hidden successfully',
        ));
      },
    );
  }

  /// Close/delete a hidden post row.
  void closeHiddenPost({required int postId}) {
    closedPostIds.add(postId);
    emit(PostMenuSuccess(
      action: PostMenuAction.hide,
      postId: postId,
      message: '',
    ));
  }

  // ─── Add future menu actions below ───────────────────────────
  //
  // Future<void> reportPost({required int postId}) async { ... }
  // Future<void> editPost({required int postId}) async { ... }
  // Future<void> deletePost({required int postId}) async { ... }
}
