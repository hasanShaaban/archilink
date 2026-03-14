class ReplyTarget {
  final String username;
  final int? commentId;

  const ReplyTarget({
    required this.username,
    this.commentId,
  });

  bool get isReply => commentId != null;
}