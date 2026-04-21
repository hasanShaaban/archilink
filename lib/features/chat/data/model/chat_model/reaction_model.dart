import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/reaction_entity.dart';

class ReactionModel extends ReactionEntity {
  const ReactionModel({
    required super.userId,
    required super.reaction,
    required super.createdAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      userId: json['user_id'] as int,
      reaction: json['reaction'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
