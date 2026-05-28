import 'package:dio/dio.dart';

import '../../core/config/api_config.dart';
import '../../products/domain/product_model.dart';
import '../domain/promotion_model.dart';

class HomeRepository {
  HomeRepository({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await _dio.get('/home/featured');
    final items = _extractList(response.data);
    return items.map(ProductModel.fromJson).toList();
  }

  Future<List<ProductModel>> getDeals() async {
    final response = await _dio.get('/home/deals');
    final items = _extractList(response.data);
    return items.map(ProductModel.fromJson).toList();
  }

  Future<List<PromotionModel>> getActivePromotions() async {
    final response = await _dio.get('/home/promotions');
    final items = _extractList(response.data);
    return items.map(PromotionModel.fromJson).toList();
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    return const [];
  }
}
