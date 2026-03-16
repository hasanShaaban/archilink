import 'dart:async';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_node.dart';
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

    on<SyncPostLike>(_onSyncPostLike);
    on<LoadComments>(_onLoadComments);
    on<LoadMoreComments>(_onLoadMoreComments);
    on<LoadReplies>(_onLoadReplies);
    on<LoadMoreReplies>(_onLoadMoreReplies);
    on<ToggleCommentLike>(_onToggleCommentLike);
    on<RefreshPostDetails>(_onRefreshPostDetails);
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
            comments: data.comments
                .map((c) => CommentNode(comment: c))
                .toList(),
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
        final updatedComments = [
          ...state.comments,
          ...data.comments.map((c) => CommentNode(comment: c)),
        ];
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

  Future<void> _onLoadReplies(
    LoadReplies event,
    Emitter<PostDetailsState> emit,
  ) async {
    final loadingComments = _updateCommentNode(
      state.comments,
      event.commentId,
      (node) => node.copyWith(isLoadingReplies: true),
    );

    if (identical(loadingComments, state.comments)) return;

    emit(state.copyWith(comments: loadingComments));

    final result = await repo.getCommentReplies(event.commentId, 1);

    result.fold(
      (failure) {
        final failedComments = _updateCommentNode(
          state.comments,
          event.commentId,
          (node) => node.copyWith(isLoadingReplies: false),
        );

        if (!identical(failedComments, state.comments)) {
          emit(state.copyWith(comments: failedComments));
        }
      },
      (data) {
        final replies = data.comments
            .map((e) => CommentNode(comment: e))
            .toList();

        final updatedComments = _updateCommentNode(
          state.comments,
          event.commentId,
          (node) => node.copyWith(
            isLoadingReplies: false,
            replies: replies,
            currentRepliesPage: data.pagination.currentPage,
            repliesReachedMax: !data.pagination.hasMore,
          ),
        );

        if (!identical(updatedComments, state.comments)) {
          emit(state.copyWith(comments: updatedComments));
        }
      },
    );
  }

  Future<void> _onLoadMoreReplies(
    LoadMoreReplies event,
    Emitter<PostDetailsState> emit,
  ) async {
    CommentNode? targetNode;
    _updateCommentNode(state.comments, event.commentId, (node) {
      targetNode = node;
      return node;
    });

    if (targetNode == null) return;
    if (targetNode!.isLoadingMoreReplies || targetNode!.repliesReachedMax) {
      return;
    }

    final loadingComments = _updateCommentNode(
      state.comments,
      event.commentId,
      (node) => node.copyWith(isLoadingMoreReplies: true),
    );

    if (identical(loadingComments, state.comments)) return;

    emit(state.copyWith(comments: loadingComments));

    final nextPage = targetNode!.currentRepliesPage + 1;

    final result = await repo.getCommentReplies(event.commentId, nextPage);

    result.fold(
      (failure) {
        final failedComments = _updateCommentNode(
          state.comments,
          event.commentId,
          (node) => node.copyWith(isLoadingMoreReplies: false),
        );

        if (!identical(failedComments, state.comments)) {
          emit(state.copyWith(comments: failedComments));
        }
      },
      (data) {
        final replies = data.comments
            .map((e) => CommentNode(comment: e))
            .toList();

        final updatedComments = _updateCommentNode(
          state.comments,
          event.commentId,
          (node) => node.copyWith(
            isLoadingMoreReplies: false,
            replies: [...node.replies, ...replies],
            currentRepliesPage: data.pagination.currentPage,
            repliesReachedMax: !data.pagination.hasMore,
          ),
        );

        if (!identical(updatedComments, state.comments)) {
          emit(state.copyWith(comments: updatedComments));
        }
      },
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
    CommentNode? originalNode;

    final updatedComments = _updateCommentLike(
      state.comments,
      event.commentId,
      (node) {
        originalNode = node;

        final newLiked = !node.comment.likedByMe;

        final newCount = newLiked
            ? node.comment.likesCount + 1
            : node.comment.likesCount - 1;

        return node.copyWith(
          comment: node.comment.copyWith(
            likedByMe: newLiked,
            likesCount: newCount,
          ),
        );
      },
    );

    emit(state.copyWith(comments: updatedComments));

    final result = await repo.toggleCommentLike(event.commentId);

    result.fold((failure) {
      if (originalNode == null) return;

      final revertedComments = _updateCommentLike(
        state.comments,
        event.commentId,
        (_) => originalNode!,
      );

      emit(state.copyWith(comments: revertedComments));
    }, (_) {});
  }

  Future<void> _onRefreshPostDetails(
    RefreshPostDetails event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoadingPost: true));
    final result = await repo.refreshPostDetails(state.post.id);
    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingPost: false, failure: failure));
      },
      (data) {
        emit(state.copyWith(isLoadingPost: false, post: data));
      },
    );
  }

  List<CommentNode> _updateCommentLike(
    List<CommentNode> nodes,
    int commentId,
    CommentNode Function(CommentNode node) updater,
  ) {
    return nodes.map((node) {
      if (node.comment.id == commentId) {
        return updater(node);
      }

      if (node.replies.isNotEmpty) {
        return node.copyWith(
          replies: _updateCommentLike(node.replies, commentId, updater),
        );
      }

      return node;
    }).toList();
  }

  List<CommentNode> _updateCommentNode(
    List<CommentNode> nodes,
    int commentId,
    CommentNode Function(CommentNode node) updater,
  ) {
    var didChange = false;

    final updated = nodes.map((node) {
      if (node.comment.id == commentId) {
        didChange = true;
        return updater(node);
      }

      if (node.replies.isNotEmpty) {
        final updatedReplies = _updateCommentNode(
          node.replies,
          commentId,
          updater,
        );
        if (!identical(updatedReplies, node.replies)) {
          didChange = true;
          return node.copyWith(replies: updatedReplies);
        }
      }

      return node;
    }).toList();

    return didChange ? updated : nodes;
  }

  @override
  Future<void> close() {
    _likeSubscription.cancel();
    return super.close();
  }
}
