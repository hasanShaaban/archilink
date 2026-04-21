class ReactionEntity {
  final int userId;
  final String reaction;
  final DateTime createdAt;

  const ReactionEntity({
    required this.userId,
    required this.reaction,
    required this.createdAt,
  });
}