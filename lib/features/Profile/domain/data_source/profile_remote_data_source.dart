import 'package:archilink/features/Post/data/models/posts_model.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required String username});
  Future<PostsModel> getMyPosts(int page);
}
