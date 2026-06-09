import 'package:computer_shop/features/products/data/products_repository.dart';
import 'package:computer_shop/features/products/data/products_repository_hybrid.dart';

import '../../products/domain/product_model.dart';
import '../domain/promotion_model.dart';

class HomeRepository {
  final dynamic _productsRepository;

  HomeRepository({dynamic productsRepository})
    : _productsRepository = productsRepository ?? ProductsRepository();

  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final result = await _productsRepository.getProducts(
      const ProductFilters(featuredOnly: true),
      page: 1,
    );
    return result.items;
  }

  Future<List<ProductModel>> getDeals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final result = await _productsRepository.getProducts(
      const ProductFilters(dealOnly: true),
      page: 1,
    );
    return result.items;
  }

  Future<List<PromotionModel>> getActivePromotions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      PromotionModel(
        promotionId: '1',
        title: 'Summer Sale',
        description: 'Get 20% off selected items',
        promoType: 'discount',
        bannerUrl: '',
        isActive: true,
        startDate: DateTime.now().toIso8601String(),
        endDate: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      ),
    ];
  }
}
