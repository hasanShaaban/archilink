import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Store/data/models/category_feed_model.dart';
import 'package:archilink/features/Store/data/models/product_feed_model.dart';
import 'package:archilink/features/Store/domain/data_source/store_remote_date_source.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:dio/dio.dart';

class StoreRemoteDataSourceImpl implements StoreRemoteDateSource {
  final ApiService _apiService;

  StoreRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;
  @override
  Future<ProductFeedEntity> getProducts(int page) async {
    try {
      final response = await _apiService.get('home/product-feed?page=$page');
      final data = response.data?['data'];
      if (data == null) {
        throw ServerException(message: 'Invalid data response');
      }
      return ProductFeedModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<CategoryFeedEntity> getCategories({int page = 1}) async {
    try {
      final response = await _apiService.get(
        'store/products/public/categories?page=$page',
      );
      final dataField = response.data?['data'];
      if (dataField == null) {
        throw ServerException(message: 'Invalid data response');
      }

      if (dataField is Map<String, dynamic>) {
        return CategoryFeedModel.fromJson(dataField).toEntity();
      } else if (dataField is List) {
        return CategoryFeedModel.fromJson({'data': dataField}).toEntity();
      }

      throw ServerException(message: 'Invalid data format');
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}

