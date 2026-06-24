// lib/features/products/presentation/providers/products_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/products_repository_hybrid.dart';
import '../../data/products_repository.dart';

// Provider for hybrid repository
final productsRepositoryProvider = Provider<ProductsRepositoryHybrid>((ref) {
  return ProductsRepositoryHybrid();
});

// Keep existing products provider (no changes needed)
final productsProvider = AsyncNotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);

class ProductsNotifier extends AsyncNotifier<ProductsState> {
  late final ProductsRepositoryHybrid _repository;

  @override
  Future<ProductsState> build() async {
    _repository = ref.read(productsRepositoryProvider);
    final filters = const ProductFilters();
    final result = await _repository.getProducts(filters, page: 1, forceRefresh: true);
    return ProductsState(
      items: result.items,
      page: result.page,
      hasMore: result.hasMore,
      filters: filters,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    if (state is! AsyncData<ProductsState>) return;
    final current = state.value!;
    if (current.isLoadingMore || !current.hasMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final result = await _repository.getProducts(
        current.filters,
        page: current.page + 1,
        forceRefresh: true,
      );

      state = AsyncValue.data(
        current.copyWith(
          items: [...current.items, ...result.items],
          page: result.page,
          hasMore: result.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> applyFilter(ProductFilters filters) async {
    state = const AsyncValue.loading();

    try {
      final result = await _repository.getProducts(
        filters,
        page: 1,
        forceRefresh: true,
      );

      state = AsyncValue.data(
        ProductsState(
          items: result.items,
          page: result.page,
          hasMore: result.hasMore,
          filters: filters,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> resetFilters() async {
    final filters = const ProductFilters();
    state = const AsyncValue.loading();

    try {
      final result = await _repository.getProducts(
        filters,
        page: 1,
        forceRefresh: true,
      );

      state = AsyncValue.data(
        ProductsState(
          items: result.items,
          page: result.page,
          hasMore: result.hasMore,
          filters: filters,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}