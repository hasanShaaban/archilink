import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Post/data/models/posts_model.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/follow_status.dart';
import 'package:archilink/features/Store/data/models/product_feed_model.dart';
import 'package:dio/dio.dart';


class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;
  ProfileRemoteDataSourceImpl(this.apiService);
  @override
  Future<ProfileModel> getProfile({required String username}) async {
    try {
      final response = await apiService.get<Map<String, dynamic>>(
        'user/$username',
      );
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid profile response');
      }
      return ProfileModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<ProfileModel> getPersonalStoreProfile() async {
    try {
      final response = await apiService.get<Map<String, dynamic>>(
        'store/profile',
      );
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid store profile response');
      }
      return ProfileModel.fromStoreJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<ProfileModel> getStoreProfile({
    required int id,
    String? handle,
  }) async {
    try {
      final response = await apiService.get<Map<String, dynamic>>(
        'store/profile/$id',
      );
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid store profile response');
      }

      final resolvedHandle = handle ?? (data['handle'] as String?) ?? '';
      bool isFollowing = false;
      int? followCount;

      if (resolvedHandle.isNotEmpty) {
        try {
          final followResponse = await apiService.get<Map<String, dynamic>>(
            'user/$resolvedHandle/follow-info',
          );
          final followData = followResponse.data?['data'];
          if (followData != null) {
            isFollowing = (followData['is_following'] as bool?) ?? false;
            followCount = (followData['followers_count'] as num?)?.toInt();
          }
        } catch (_) {
          // Graceful fallback if follow-info fails
        }
      }

      return ProfileModel.fromStoreJson(
        data,
        isFollowing: isFollowing,
        followCount: followCount,
      );
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<ProductFeedModel> getStoreProducts({
    required int storeId,
    int page = 1,
  }) async {
    try {
      final response = await apiService.get<Map<String, dynamic>>(
        'store/$storeId/products?page=$page',
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid store products response');
      }
      return ProductFeedModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<PostsModel> getMyPosts(int page) async {
    try {
      final response = await apiService.get('post-center/my-posts?page=$page');
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid profile reponse');
      }
      return PostsModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<PostsModel> getProfilePosts({
    required String username,
    required int page,
  }) async {
    try {
      final response = await apiService.get('user/$username/posts?page=$page');
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid profile reponse');
      }
      return PostsModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<FollowStatus> follow(String username) async {
    try {
      final response = await apiService.post('user-relations/follow/$username');
      final status = response.data?['status'];
      final message = response.data?['message'] as String?;
      if (status == null) {
        throw ServerException(message: 'Invalid follow response');
      }
      if (status == 'fail' && response.data?['error'] != null) {
        throw ServerException(message: 'You are already following this user.');
      }
      // "Requested Successfully." → private profile, follow request pending.
      // "User Followed Successfully." → public profile, immediately followed.
      if (message != null && message.toLowerCase().contains('request')) {
        return FollowStatus.requested;
      }
      return FollowStatus.followed;
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }


  @override
  Future<bool> unfollow(String username) async {
    try {
      final response = await apiService.delete(
        'user-relations/unfollow/$username',
      );

      final status = response.data?['status'];
      if (status == null) {
        throw ServerException(message: 'Invalid profile reponse');
      }
      if (status == 'fail' && response.data?['error'] != null) {
        throw ServerException(message: 'You are already following this user.');
      }
      return status == 'success' ? true : false;
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
