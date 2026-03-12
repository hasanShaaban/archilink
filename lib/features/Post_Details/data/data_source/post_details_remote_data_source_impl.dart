
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Post_Details/data/models/post_comments_model.dart';
import 'package:archilink/features/Post_Details/domain/data_source/post_details_remote_data_source.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';
import 'package:dio/dio.dart';

class PostDetailsRemoteDataSourceImpl implements PostDetailsRemoteDataSource{
  final ApiService apiService;

  PostDetailsRemoteDataSourceImpl(this.apiService);
  @override
  Future<PostCommentsEntity> getPostComments(int postId, int page) async{
    try{
      final response = await apiService.get('post-center/post/$postId/comments?page=$page');
      final data = response.data?['data'];
      if(data == null){
        throw ServerException(message: "Invalid data response");
      }
      return PostCommentsModel.fromJson(response.data!);
    }on DioException catch(e){
      throw AppException.handelDioException(e);
    }}
}