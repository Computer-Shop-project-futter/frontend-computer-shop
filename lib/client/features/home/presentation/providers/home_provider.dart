// think of manager as a controller that manages the state of the home page,
// it will fetch data from the repository and update the state accordingly. The home page will listen to the state
// changes and rebuild the UI accordingly.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/home_repository.dart';
import '../../domain/promotion_model.dart';
import '../../../products/domain/product_model.dart';
import '../../../products/presentation/providers/products_provider.dart';

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
  // Use hybrid products repository for featured/deal products
  final productsRepo = ref.read(productsRepositoryProvider);
  return HomeRepository(productsRepository: productsRepo);
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
