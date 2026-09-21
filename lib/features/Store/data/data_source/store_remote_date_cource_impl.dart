import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/functions/product_form_data_builder.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Store/data/models/category_feed_model.dart';
import 'package:archilink/features/Store/data/models/product_feed_model.dart';
import 'package:archilink/features/Store/data/models/product_model.dart';
import 'package:archilink/features/Store/domain/data_source/store_remote_date_source.dart';
import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
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

  @override
  Future<ProductEntity> addProduct(AddProductParams params) async {
    try {
      final formData = await buildProductFormData(params);
      final response = await _apiService.postForm(
        'store/products',
        formData: formData,
      );
      final dataField = response.data?['data'];
      if (dataField == null || dataField is! Map<String, dynamic>) {
        throw ServerException(message: 'Invalid add product response');
      }
      return ProductModel.fromJson(dataField).toEntity();
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<ProductEntity> editProduct(EditProductParams params) async {
    try {
      final data = await buildEditProductData(params);
      final response = await _apiService.patch(
        'store/products/${params.id}',
        body: data,
      );
      final dataField = response.data?['data'];
      if (dataField != null && dataField is Map<String, dynamic>) {
        return ProductModel.fromJson(dataField).toEntity();
      }
      final status = response.data?['status'];
      if (status != null && status != 'success') {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to edit product',
        );
      }
      return ProductEntity(
        id: params.id,
        store: const ProductStoreEntity(
          id: 0,
          name: '',
          username: '',
        ),
        name: params.name ?? '',
        description: params.description ?? '',
        price: params.price ?? 0.0,
        quantityInStock: params.quantityInStock ?? 0,
        sku: '',
        status: params.status ?? 'available',
      );
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _apiService.delete('store/products/$id');
      final status = response.data?['status'];
      if (status != null && status != 'success') {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to delete product',
        );
      }
      return true;
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }

  @override
  Future<ProductFeedEntity> searchProducts({
    String? query,
    String? minPrice,
    String? maxPrice,
    int page = 1,
  }) async {
    try {
      if (query == null || query.trim().isEmpty) {
        return getProducts(page);
      }

      final body = <String, dynamic>{
        'q': query.trim(),
      };
      if (minPrice != null && minPrice.trim().isNotEmpty) {
        body['min_price'] = minPrice.trim();
      }
      if (maxPrice != null && maxPrice.trim().isNotEmpty) {
        body['max_price'] = maxPrice.trim();
      }

      final response = await _apiService.post(
        'home/search/products?page=$page',
        body: body,
      );

      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Invalid data response');
      }

      final dataField = data is Map<String, dynamic> && data.containsKey('data')
          ? data['data']
          : data;

      if (dataField == null) {
        throw ServerException(message: 'Invalid data response');
      }

      return ProductFeedModel.fromJson(dataField as Map<String, dynamic>).toEntity();
    } on DioException catch (e) {
      throw AppException.handelDioException(e);
    }
  }
}


