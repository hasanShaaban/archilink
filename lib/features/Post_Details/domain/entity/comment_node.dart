import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';

class CommentNode {
  final CommentEntity comment;
  final List<CommentNode> replies;

  final bool isLoadingReplies;
  final bool isLoadingMoreReplies;
  final int currentRepliesPage;
  final bool repliesReachedMax;

  final bool isPending;

  CommentNode({
    required this.comment,
    this.replies = const [],
    this.isLoadingReplies = false,
    this.isLoadingMoreReplies = false,
    this.currentRepliesPage = 1,
    this.repliesReachedMax = false,
    this.isPending = false,
  });

  CommentNode copyWith({
    CommentEntity? comment,
    List<CommentNode>? replies,
    bool? isLoadingReplies,
    bool? isLoadingMoreReplies,
    int? currentRepliesPage,
    bool? repliesReachedMax,
    bool? isPending,

  }) {
    return CommentNode(
      comment: comment ?? this.comment,
      replies: replies ?? this.replies,
      isLoadingReplies: isLoadingReplies ?? this.isLoadingReplies,
      isLoadingMoreReplies: isLoadingMoreReplies ?? this.isLoadingMoreReplies,
      currentRepliesPage: currentRepliesPage ?? this.currentRepliesPage,
      repliesReachedMax: repliesReachedMax ?? this.repliesReachedMax,
      isPending: isPending ?? this.isPending,

    );
  }
}
