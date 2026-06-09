import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:computer_shop/home/data/home_repository.dart';
import 'package:computer_shop/home/domain/promotion_model.dart';
import 'package:computer_shop/home/presentation/providers/home_provider.dart';
import 'package:computer_shop/features/products/domain/product_model.dart';

class FakeHomeRepository extends HomeRepository {
  FakeHomeRepository({
    required this.featured,
    required this.deals,
    required this.promotions,
  });

  final List<ProductModel> featured;
  final List<ProductModel> deals;
  final List<PromotionModel> promotions;

  @override
  Future<List<ProductModel>> getFeaturedProducts() async => featured;

  @override
  Future<List<ProductModel>> getDeals() async => deals;

  @override
  Future<List<PromotionModel>> getActivePromotions() async => promotions;
}

void main() {
  test('homeProvider loads featured, deals, and promotions', () async {
    final featured = [
      const ProductModel(
        productId: 'p1',
        categoryId: 'c1',
        brandId: 'b1',
        name: 'Rig One',
        shortDescription: 'Fast rig',
        basePrice: 2000,
        dealPrice: null,
        thumbnailUrl: 'https://example.com/rig.png',
        isFeatured: true,
        isDeal: false,
        isActive: true,
      ),
    ];
    final deals = [
      const ProductModel(
        productId: 'p2',
        categoryId: 'c1',
        brandId: 'b1',
        name: 'Deal Rig',
        shortDescription: 'Hot deal',
        basePrice: 1800,
        dealPrice: 1600,
        thumbnailUrl: 'https://example.com/deal.png',
        isFeatured: false,
        isDeal: true,
        isActive: true,
      ),
    ];
    final promotions = [
      const PromotionModel(
        promotionId: 'promo1',
        title: 'Promo',
        description: 'Save big',
        promoType: 'SEASONAL',
        startDate: '2026-05-20',
        endDate: '2026-06-03',
        bannerUrl: 'https://example.com/banner.png',
        isActive: true,
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          FakeHomeRepository(
            featured: featured,
            deals: deals,
            promotions: promotions,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(homeProvider.future);

    expect(state.featuredProducts, featured);
    expect(state.deals, deals);
    expect(state.promotions, promotions);
  });
}
