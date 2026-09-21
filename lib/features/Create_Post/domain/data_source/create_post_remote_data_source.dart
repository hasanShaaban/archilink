import 'package:archilink/features/Create_Post/domain/entity/create_post_parms.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_response_entity.dart';

abstract class CreatePostRemoteDataSource {
  Future<CreatePostResponseEntity> createPost(CreatePostParms parms);
  Future<bool> updatePost({
    required int postId,
    required String body,
    required String privacy,
  });
}
