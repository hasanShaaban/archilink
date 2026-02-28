import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Home/data/model/global_feed_model.dart';
import 'package:archilink/features/Home/domain/data_source/home_remote_data_source.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource{
  final ApiService apiService;

  HomeRemoteDataSourceImpl(this.apiService);
  
  @override
  Future<GlobalFeedModel> getGlobalFeed({required int page}) async{
    try {
      final response = await apiService.get('home/global-feed?page=$page');
      final data = response.data?['data'];
      if(data == null){
        throw ServerException(message: "Invalid data response");
      }
      return GlobalFeedModel.fromJson(response.data!);

    }on DioException catch(e){
      throw AppException.handelDioException(e);
    }
  }
}