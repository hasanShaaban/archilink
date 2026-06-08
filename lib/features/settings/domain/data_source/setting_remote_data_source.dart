import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';
import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';
import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';

abstract class SettingRemoteDataSource {
  Future<bool> logOut();
  Future<FollowersAndFollowingsEntity> getFollowers({
    required String username,
    required int page,
  });
  Future<FollowersAndFollowingsEntity> getFollowing({
    required String username,
    required int page,
  });
  Future<LikedPostsEntity> getLikedPosts({required int page});
  Future<CommentsHistoryEntity> getCommentsHistory({required int page});
  Future<List<UserCollectionEntity>> getCollections();
  Future<CustomerSupportChatEntity> getCustomerSupportChatDetails();
}
