import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Edit_Profile/data/model/universities_response_model.dart';
import 'package:archilink/features/Edit_Profile/domain/data_source/edit_profile_remote_data_source.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/universities_response_entity.dart';
import 'package:dio/dio.dart';

class EditProfileRemoteDataSourceImpl extends EditProfileRemoteDataSource {
  final ApiService apiService;

  EditProfileRemoteDataSourceImpl(this.apiService);
  @override
  Future<UniversitiesResponseEntity> getUniversities() async {
    try {
      final response = await apiService.get('utils/universities');
      final data = response.data;
      if (data == null) {
        throw ServerException(message: "Invalid data response");
      }
      return UniversitiesResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}
