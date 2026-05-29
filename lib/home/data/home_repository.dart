import '../../products/domain/product_model.dart';
import '../domain/promotion_model.dart';

class HomeRepository {
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ProductModel(
        productId: '1',
        name: 'Featured Laptop',
        shortDescription: 'High performance laptop',
        basePrice: 999.99,
        categoryId: 'laptops',
        brandId: 'brand1',
        thumbnailUrl: '',
        isFeatured: true,
        isDeal: false,
        dealPrice: null,
        isActive: true,
      ),
    ];
  }

  Future<List<ProductModel>> getDeals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ProductModel(
        productId: '2',
        name: 'Deal Monitor',
        shortDescription: 'Great monitor deal',
        basePrice: 299.99,
        categoryId: 'monitors',
        brandId: 'brand2',
        thumbnailUrl: '',
        isFeatured: false,
        isDeal: true,
        dealPrice: 199.99,
        isActive: true,
      ),
    ];
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
