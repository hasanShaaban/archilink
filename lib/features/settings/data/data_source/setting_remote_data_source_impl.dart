import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/settings/domain/data_source/setting_remote_data_source.dart';
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
}
