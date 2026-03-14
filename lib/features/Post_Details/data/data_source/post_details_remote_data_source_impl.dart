import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Post/data/models/post_model.dart';
import 'package:archilink/features/Post_Details/data/models/add_comment_response_model.dart';
import 'package:archilink/features/Post_Details/data/models/post_comments_model.dart';
import 'package:archilink/features/Post_Details/domain/data_source/post_details_remote_data_source.dart';
import 'package:archilink/features/Post_Details/domain/entity/add_comment_response_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';
import 'package:dio/dio.dart';

class PostDetailsRemoteDataSourceImpl implements PostDetailsRemoteDataSource {
  final ApiService apiService;

  PostDetailsRemoteDataSourceImpl(this.apiService);
  @override
  Future<PostCommentsEntity> getPostComments(int postId, int page) async {
    try {
      final response = await apiService.get(
        'post-center/post/$postId/comments?page=$page',
      );
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: "Invalid data response");
      }
      return PostCommentsModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<bool> toggleCommentLike(int commentId) async {
    try {
      final response = await apiService.post('comments/$commentId/toggle-like');
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
  Future<PostModel> refreshPostDetails(int postId) async {
    try {
      final reseponse = await apiService.get('post-center/post/$postId');
      final data = reseponse.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid data response');
      }
      return PostModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<AddCommentResponseEntity> addComment({
    required int postId,
    required String body,
    int? parentId,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {"body": body};

      if (parentId != null) {
        requestBody["parent_id"] = parentId;
      }
      final response = await apiService.post(
        'posts/$postId/comment',
        body: requestBody,
      );
      return AddCommentResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
