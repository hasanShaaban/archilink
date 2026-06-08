import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';
import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';
import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:archilink/features/settings/domain/entity/send_support_message_response_entity.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_messages_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SettingRepo {
  Future<Either<Failure, bool>> logOut();
  Future<Either<Failure, FollowersAndFollowingsEntity>> getFollowers({
    required String username,
    required int page,
  });
  Future<Either<Failure, FollowersAndFollowingsEntity>> getFollowing({
    required String username,
    required int page,
  });
  Future<Either<Failure, LikedPostsEntity>> getLikedPosts({required int page});
  Future<Either<Failure, CommentsHistoryEntity>> getCommentsHistory({
    required int page,
  });
  Future<Either<Failure, List<UserCollectionEntity>>> getCollections();
  Future<Either<Failure, CustomerSupportChatEntity>>
  getCustomerSupportChatDetails();
  Future<Either<Failure, CustomerSupportMessagesEntity>>
  getCustomerSupportMessages({required int page});
  Future<Either<Failure, SendSupportMessageResponseEntity>> sendSupportMessage({
    required String message,
  });
}
