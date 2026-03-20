import 'package:archilink/features/Post/data/models/posts_model.dart';

abstract class HomeRemoteDataSource {
  Future<PostsModel> getGlobalFeed({required int page});
}