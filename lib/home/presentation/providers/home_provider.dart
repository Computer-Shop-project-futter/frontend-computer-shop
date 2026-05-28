import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/home_repository.dart';
import '../../domain/promotion_model.dart';
import '../../../products/domain/product_model.dart';

class HomeState {
  final List<ProductModel> featuredProducts;
  final List<ProductModel> deals;
  final List<PromotionModel> promotions;

  const HomeState({
    required this.featuredProducts,
    required this.deals,
    required this.promotions,
  });
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository();
});

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

class HomeNotifier extends AsyncNotifier<HomeState> {
  late final HomeRepository _repository;

  @override
  Future<HomeState> build() async {
    _repository = ref.read(homeRepositoryProvider);

    final results = await Future.wait([
      _repository.getFeaturedProducts(),
      _repository.getDeals(),
      _repository.getActivePromotions(),
    ]);

    return HomeState(
      featuredProducts: results[0] as List<ProductModel>,
      deals: results[1] as List<ProductModel>,
      promotions: results[2] as List<PromotionModel>,
    );
  }
}
