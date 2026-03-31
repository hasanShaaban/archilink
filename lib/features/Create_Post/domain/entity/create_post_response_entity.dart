import 'package:archilink/features/Create_Post/domain/entity/create_post_entity.dart';

class CreatePostResponseEntity {
  final String status;
  final String message;
  final CreatePostEntity post;

  const CreatePostResponseEntity({
    required this.status,
    required this.message,
    required this.post,
  });
}
