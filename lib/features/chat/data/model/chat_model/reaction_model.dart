import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/reaction_entity.dart';

class ReactionModel extends ReactionEntity {
  const ReactionModel({
    required super.userId,
    required super.reaction,
    required super.createdAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    final rawUserId = json['user_id'] ?? json['userId'];
    final userId = rawUserId != null
        ? int.tryParse(rawUserId.toString()) ??
            ((rawUserId is num) ? rawUserId.toInt() : 0)
        : 0;

    final rawReaction = json['reaction'];
    final reactionStr = rawReaction is String
        ? rawReaction
        : (rawReaction is Map
            ? (rawReaction['reaction']?.toString() ?? '')
            : (rawReaction?.toString() ?? ''));

    final rawCreatedAt = json['created_at'] ?? json['createdAt'];
    final createdAt = rawCreatedAt != null
        ? DateTime.tryParse(rawCreatedAt.toString()) ?? DateTime.now()
        : DateTime.now();

    return ReactionModel(
      userId: userId,
      reaction: reactionStr,
      createdAt: createdAt,
    );
  }
}
