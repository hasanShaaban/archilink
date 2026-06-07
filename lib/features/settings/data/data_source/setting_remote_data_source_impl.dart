import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/settings/data/model/comments_history_model.dart';
import 'package:archilink/features/settings/data/model/followers_and_following_model.dart';
import 'package:archilink/features/settings/data/model/liked_posts_model.dart';
import 'package:archilink/features/settings/data/model/user_collection_model.dart';
import 'package:archilink/features/settings/domain/data_source/setting_remote_data_source.dart';
import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';
import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';
import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:dio/dio.dart';

class SettingRemoteDataSourceImpl extends SettingRemoteDataSource {
  final ApiService apiService;

  SettingRemoteDataSourceImpl(this.apiService);
  @override
  Future<bool> logOut() async {
    try {
      final response = await apiService.delete('account-center/logout');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid check username response');
      }
      return data['status'] == 'success';
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<FollowersAndFollowingsEntity> getFollowers({
    required String username,
    required int page,
  }) async {
    try {
      final response = await apiService.get(
        'user/$username/followers',
        query: {'page': page},
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid check username response');
      }
      return FollowersAndFollowingModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<FollowersAndFollowingsEntity> getFollowing({
    required String username,
    required int page,
  }) async {
    try {
      final response = await apiService.get(
        'user/$username/following',
        query: {'page': page},
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid check username response');
      }
      return FollowersAndFollowingModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<LikedPostsEntity> getLikedPosts({required int page}) async {
    try {
      final response = await apiService.get(
        'account-center/settings/my-activity?type=likes',
        query: {'page': page},
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid liked posts response');
      }
      return LikedPostsModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<CommentsHistoryEntity> getCommentsHistory({required int page}) async {
    try {
      final response = await apiService.get(
        'account-center/settings/my-activity?type=comments',
        query: {'page': page},
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid comments history response');
      }
      return CommentsHistoryModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<List<UserCollectionEntity>> getCollections() async {
    try {
      final response = await apiService.get('collections/my-collections');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid collections response');
      }
      return UserCollectionModel.fromJsonList(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
