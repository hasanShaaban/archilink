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
}
