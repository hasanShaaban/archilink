import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Profile/data/model/user_profile_model.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:dio/dio.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;
  ProfileRemoteDataSourceImpl(this.apiService);
  @override
  Future<UserProfileResponseModel> getProfile({required String username}) async{
    try{
      final response = await apiService.get<Map<String, dynamic>>('user/$username');
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid profile response');
      }
      return UserProfileResponseModel.fromJson(data);

    }on DioException catch(e){
      throw AppException.handelDioException(e);
    }
  }
}