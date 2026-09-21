abstract class PostRemoteDataSource {
  Future<bool> togglePostLike({required int postId});
  Future<bool> interestPost({required int postId});
  Future<bool> hidePost({required int postId});
  Future<bool> savePost({required int postId, required collectionId});
  Future<bool> deletePost({required int postId});
}
