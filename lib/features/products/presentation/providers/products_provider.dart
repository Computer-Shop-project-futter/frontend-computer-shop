// lib/features/products/presentation/providers/products_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/products_repository_hybrid.dart';
import '../../data/products_repository_supabase.dart';
import '../../data/products_repository_sqlite.dart';
import '../../data/products_repository.dart';
import '../../domain/product_model.dart';

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
    final result = await _repository.getProducts(filters, page: 1);
    return ProductsState(
      items: result.items,
      page: result.page,
      hasMore: result.hasMore,
      filters: filters,
      isLoadingMore: false,
    );
  }

  // Rest of your existing methods remain the same
  Future<void> loadMore() async { /* existing code */ }
  Future<void> applyFilter(ProductFilters filters) async { /* existing code */ }
  Future<void> resetFilters() async { /* existing code */ }
}