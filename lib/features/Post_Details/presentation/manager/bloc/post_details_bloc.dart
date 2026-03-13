import 'dart:async';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/utils/temp.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/repo/post_details_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_details_event.dart';
part 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final PostLikeCubit interactions;
  final PostDetailsRepo repo;
  late final StreamSubscription _likeSubscription;
  PostDetailsBloc(PostEntity post, this.interactions, this.repo)
    : super(PostDetailsState(post: post)) {
    _likeSubscription = interactions.stream.listen((event) {
      if (event == null) return;

      add(
        SyncPostLike(
          postId: event.postId,
          liked: event.liked,
          likesCont: event.likeCount,
        ),
      );
    });

    on<ToggleLikePost>(_onToggleLike);
    on<SyncPostLike>(_onSyncPostLike);
    on<LoadComments>(_onLoadComments);
    on<LoadMoreComments>(_onLoadMoreComments);
    on<ToggleCommentLike>(_onToggleCommentLike);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoadingComments: true));

    final result = await repo.getPostComments(state.post.id, 1);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingComments: false, failure: failure));
      },
      (data) {
        emit(
          state.copyWith(
            comments: data.comments,
            isLoadingComments: false,
            currentPage: data.pagination.currentPage,
            hasReachedMax: !data.pagination.hasMore,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreComments(
    LoadMoreComments event,
    Emitter<PostDetailsState> emit,
  ) async {
    if (state.isLoadingComments || state.hasReachedMax) return;

    emit(state.copyWith(isLoadingMoreComments: true));

    final nextPage = state.currentPage + 1;
    final result = await repo.getPostComments(state.post.id, nextPage);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMoreComments: false, failure: failure));
      },
      (data) {
        final updatedComments = [...state.comments, ...data.comments];
        emit(
          state.copyWith(
            comments: updatedComments,
            isLoadingMoreComments: false,
            currentPage: data.pagination.currentPage,
            hasReachedMax: !data.pagination.hasMore,
          ),
        );
      },
    );
  }

  void _onToggleLike(ToggleLikePost event, Emitter<PostDetailsState> emit) {
    interactions.toggleLike(
      postId: state.post.id,
      liked: state.post.likedByMe,
      likeCount: state.post.likesCount,
    );
  }

  void _onSyncPostLike(SyncPostLike event, Emitter<PostDetailsState> emit) {
    if (event.postId != state.post.id) return;

    emit(
      state.copyWith(
        post: state.post.copyWith(
          likedByMe: event.liked,
          likesCount: event.likesCont,
        ),
      ),
    );
  }

  Future<void> _onToggleCommentLike(
    ToggleCommentLike event,
    Emitter<PostDetailsState> emit,
  ) async {
    final index = state.comments.indexWhere((c) => c.id == event.commentId);

    if (index == -1) return;

    final comment = state.comments[index];

    final newLiked = !comment.likedByMe;
    final newCount = newLiked ? comment.likesCount + 1 : comment.likesCount - 1;

    final updatedComment = comment.copyWith(
      likedByMe: newLiked,
      likesCount: newCount,
    );

    final updatedComments = List<CommentEntity>.from(state.comments);
    updatedComments[index] = updatedComment;

    emit(state.copyWith(comments: updatedComments));

    final result = await repo.toggleCommentLike(event.commentId);

    result.fold((failure) {
      updatedComments[index] = comment;
      emit(state.copyWith(comments: updatedComments));
    }, (_) {});
  }

  @override
  Future<void> close() {
    _likeSubscription.cancel();
    return super.close();
  }
}
