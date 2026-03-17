import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
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
}
