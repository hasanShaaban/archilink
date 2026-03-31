import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/functions/post_form_data_builder.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Create_Post/data/models/create_post_response_model.dart';
import 'package:archilink/features/Create_Post/domain/data_source/create_post_remote_data_source.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_parms.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_response_entity.dart';
import 'package:dio/dio.dart';

class CreatePostRemoteDateSourceImpl extends CreatePostRemoteDataSource {
  final ApiService apiService;

  CreatePostRemoteDateSourceImpl(this.apiService);
  @override
  Future<CreatePostResponseEntity> createPost(CreatePostParms parms) async {
    final fromData = await buildFormData(parms);
    try {
      final response = await apiService.postForm(
        'post-center/create-post',
        formData: fromData,
      );
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid create post response');
      }
      return CreatePostResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
