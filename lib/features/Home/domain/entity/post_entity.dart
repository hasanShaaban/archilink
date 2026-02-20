import 'package:archilink/features/Home/domain/entity/post_owner_entity.dart';

class PostEntity {
  final int id;
  final String body;
  final DateTime createdAt;
  final PostOwnerEntity owner;
  final List<String> tags;

  const PostEntity({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
    required this.tags,
  });
}