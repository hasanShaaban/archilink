import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/reaction_entity.dart';

class ReactionModel extends ReactionEntity {
  const ReactionModel({
    required super.userId,
    required super.reaction,
    required super.createdAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      userId: ((json['user_id'] ?? json['userId']) as num?)?.toInt() ?? 0,
      reaction: (json['reaction'] ?? '') as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
