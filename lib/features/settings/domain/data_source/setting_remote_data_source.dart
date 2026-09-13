import 'package:archilink/features/settings/domain/entity/collection_posts_entity.dart';
import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_messages_entity.dart';
import 'package:archilink/features/settings/domain/entity/follow_request_entity.dart';
import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';
import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:archilink/features/settings/domain/entity/send_support_message_response_entity.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';

abstract class SettingRemoteDataSource {
  Future<bool> logOut();

  //Followers and following reqests
  Future<FollowersAndFollowingsEntity> getFollowers({
    required String username,
    required int page,
  });
  Future<FollowersAndFollowingsEntity> getFollowing({
    required String username,
    required int page,
  });
  Future<FollowRequestsEntity> getOutgoingRequests({required int page});
  Future<FollowRequestsEntity> getIncomingRequests({required int page});
  Future<LikedPostsEntity> getLikedPosts({required int page});
  Future<CommentsHistoryEntity> getCommentsHistory({required int page});

  Future<CustomerSupportChatEntity> getCustomerSupportChatDetails();
  Future<CustomerSupportMessagesEntity> getCustomerSupportMessages({
    required int page,
  });
  Future<SendSupportMessageResponseEntity> sendSupportMessage({
    required String message,
  });

  //Collections reqests
  Future<List<UserCollectionEntity>> getCollections();
  Future<CollectionPostsEntity> getCollectionPosts({required int collectionId});
  Future<bool> createCollection({required String title});
  Future<bool> removeItemFromCollection({required int itemId});
  Future<bool> removeCollection({required int collectionId});
  Future<bool> editCollectionName({required String name, required int id});
}
