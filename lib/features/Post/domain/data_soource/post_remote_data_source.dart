abstract class PostRemoteDataSource {
  Future<bool> togglePostLike({required int postId});
  Future<bool> interestPost({required int postId});
}
