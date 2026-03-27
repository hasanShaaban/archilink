import 'dart:async';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_node.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_owner_entity.dart';
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
    on<AddComment>(_onAddComment);
  }
  Future<void> _onAddComment(
    AddComment event,
    Emitter<PostDetailsState> emit,
  ) async {
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final cachedProfile = await repo.getCachedProfile();
    final tempNode = cachedProfile.fold(
      (_) {
        return CommentNode(
          isPending: true,
          comment: CommentEntity(
            id: tempId,
            body: event.body,
            createdAt: DateTime.now().toIso8601String(),
            owner: CommentOwnerEntity(
              id: 0,
              name: 'Unknown',
              username: 'unknown',
            ),
            likesCount: 0,
            repliesCount: 0,
            likedByMe: false,
          ),
        );
      },
      (profile) {
        return CommentNode(
          isPending: true,
          comment: CommentEntity(
            id: tempId,
            body: event.body,
            createdAt: DateTime.now().toIso8601String(),
            owner: CommentOwnerEntity(
              id: 0,
              name: profile.name,
              username: profile.username,
            ),
            likesCount: 0,
            repliesCount: 0,
            likedByMe: false,
          ),
        );
      },
    );
    final withTemp = _insertTempComment(event.parentId, tempNode);
    emit(state.copyWith(comments: withTemp));

    final result = await repo.addComment(
      postId: state.post.id,
      body: event.body,
      parentId: event.parentId,
    );
    result.fold(
      (failure) {
        final reverted = _removeTempComment(event.parentId, tempId);
        // failure in state → UI listens and shows a Snackbar, then clears it
        emit(state.copyWith(comments: reverted, failure: failure));
      },
      (realComment) {
        final confirmed = _replaceTempComment(
          event.parentId,
          tempId,
          CommentNode(comment: realComment),
        );
        emit(state.copyWith(comments: confirmed));
      },
    );
  }

  /// Inserts [tempNode] at the top of the correct level.
  List<CommentNode> _insertTempComment(int? parentId, CommentNode tempNode) {
    if (parentId == null) {
      return [tempNode, ...state.comments];
    }
    return _updateCommentNode(
      state.comments,
      parentId,
      (node) => node.copyWith(
        comment: node.comment.copyWith(
          repliesCount: node.comment.repliesCount + 1,
        ),
        replies: [tempNode, ...node.replies],
      ),
    );
  }

  
  List<CommentNode> _replaceTempComment(
    int? parentId,
    int tempId,
    CommentNode realNode,
  ) {
    CommentNode swap(CommentNode n) => n.comment.id == tempId ? realNode : n;

    if (parentId == null) {
      return state.comments.map(swap).toList();
    }
    return _updateCommentNode(
      state.comments,
      parentId,
      (node) => node.copyWith(replies: node.replies.map(swap).toList()),
    );
  }

  
  List<CommentNode> _removeTempComment(int? parentId, int tempId) {
    bool isNotTemp(CommentNode n) => n.comment.id != tempId;

    if (parentId == null) {
      return state.comments.where(isNotTemp).toList();
    }
    return _updateCommentNode(
      state.comments,
      parentId,
      (node) {
        final hadTemp = node.replies.any((r) => r.comment.id == tempId);
        final updatedReplies = node.replies.where(isNotTemp).toList();
        return node.copyWith(
          comment: hadTemp
              ? node.comment.copyWith(
                  repliesCount:
                      (node.comment.repliesCount - 1).clamp(0, 1 << 30).toInt(),
                )
              : node.comment,
          replies: updatedReplies,
        );
      },
    );
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
    if (state.isLoadingComments ||
        state.isLoadingMoreComments ||
        state.hasReachedMax) {
      return;
    }

    emit(state.copyWith(isLoadingMoreComments: true));

    final nextPage = state.currentPage + 1;
    final result = await repo.getPostComments(state.post.id, nextPage);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMoreComments: false, failure: failure));
      },
      (data) {
        final existingIds = state.comments.map((n) => n.comment.id).toSet();
        final newNodes = data.comments
            .where((c) => !existingIds.contains(c.id))
            .map((c) => CommentNode(comment: c))
            .toList();
        final updatedComments = [...state.comments, ...newNodes];
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
        final pendingReplies =
            _findNode(state.comments, event.commentId)
                    ?.replies
                    .where((r) => r.isPending)
                    .toList() ??
                const <CommentNode>[];
        final replies = [
          ...pendingReplies,
          ...data.comments.map((e) => CommentNode(comment: e)),
        ];

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

  CommentNode? _findNode(List<CommentNode> nodes, int id) {
    for (final node in nodes) {
      if (node.comment.id == id) return node;
      final found = _findNode(node.replies, id);
      if (found != null) return found;
    }
    return null;
  }

  @override
  Future<void> close() {
    _likeSubscription.cancel();
    return super.close();
  }
}
