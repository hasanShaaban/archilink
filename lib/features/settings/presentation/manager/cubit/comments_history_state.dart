import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';
import 'package:equatable/equatable.dart';

class CommentsHistoryState extends Equatable {
  static const Object _noChange = Object();

  const CommentsHistoryState({
    this.comments = const <CommentHistoryItemEntity>[],
    this.commentsPage = 0,
    this.hasMoreComments = true,
    this.isLoadingComments = false,
    this.isLoadingMoreComments = false,
    this.commentsErrorMessage,
  });

  final List<CommentHistoryItemEntity> comments;
  final int commentsPage;
  final bool hasMoreComments;
  final bool isLoadingComments;
  final bool isLoadingMoreComments;
  final String? commentsErrorMessage;

  bool get hasCommentsData => comments.isNotEmpty;

  CommentsHistoryState copyWith({
    List<CommentHistoryItemEntity>? comments,
    int? commentsPage,
    bool? hasMoreComments,
    bool? isLoadingComments,
    bool? isLoadingMoreComments,
    Object? commentsErrorMessage = _noChange,
  }) {
    return CommentsHistoryState(
      comments: comments ?? this.comments,
      commentsPage: commentsPage ?? this.commentsPage,
      hasMoreComments: hasMoreComments ?? this.hasMoreComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingMoreComments:
          isLoadingMoreComments ?? this.isLoadingMoreComments,
      commentsErrorMessage: commentsErrorMessage == _noChange
          ? this.commentsErrorMessage
          : commentsErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    comments,
    commentsPage,
    hasMoreComments,
    isLoadingComments,
    isLoadingMoreComments,
    commentsErrorMessage,
  ];
}

final class CommentsHistoryInitial extends CommentsHistoryState {
  const CommentsHistoryInitial();
}
