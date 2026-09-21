import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Post/domain/data_soource/post_remote_data_source.dart';
import 'package:dio/dio.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiService apiService;

  PostRemoteDataSourceImpl(this.apiService);
  @override
  Future<bool> togglePostLike({required int postId}) async {
    try {
      final response = await apiService.post<Map<String, dynamic>>(
        'posts/$postId/toggle-like',
      );
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'something went wrong');
      }
      return data['liked'] as bool;
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<bool> interestPost({required int postId}) async {
    try {
      final response = await apiService.post('posts/$postId/interested');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'something went wrong');
      }
      return data['status'] == 'success';
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<bool> hidePost({required int postId}) async {
    try {
      final response = await apiService.post('posts/$postId/hide');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'something went wrong');
      }
      return data['status'] == 'success';
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<bool> savePost({required int postId, required collectionId}) async {
    try {
      final response = await apiService.post(
        'collections/$collectionId/add-item',
        body: {"collectible_type": 'post', "collectible_id": postId.toString()},
      );

      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'something went wrong');
      }
      return data['status'] == 'success';
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<bool> deletePost({required int postId}) async {
    try {
      final response = await apiService.delete('post-center/delete-post/$postId');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'something went wrong');
      }
      if (data is Map && data['status'] != null) {
        if (data['status'] == 'success') {
          return true;
        }
        throw ServerException(
          message: data['message'] ?? data['data'] ?? 'Failed to delete post',
        );
      }
      return true;
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
