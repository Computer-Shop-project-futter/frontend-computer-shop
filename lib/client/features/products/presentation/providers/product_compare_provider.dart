import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/products_repository.dart';
import 'products_provider.dart';

class CompareProductsRequest {
  final List<String> productIds;

  CompareProductsRequest({required List<String> productIds})
      : productIds = List.unmodifiable(productIds);

  @override
  bool operator ==(Object other) {
    if (other is! CompareProductsRequest) return false;
    if (other.productIds.length != productIds.length) return false;
    for (var index = 0; index < productIds.length; index++) {
      if (other.productIds[index] != productIds[index]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(productIds);
}

class CompareProductsState {
  final List<ProductDetailPayload> products;

  const CompareProductsState({required this.products});
}

final compareProductProvider =
    FutureProvider.family<CompareProductsState, CompareProductsRequest>(
  (ref, request) async {
    final repository = ref.read(productsRepositoryProvider);
    // Load each product, but catch individual failures so one missing product
    // doesn't break the whole compare screen.
    final results = await Future.wait(
      request.productIds.map((id) async {
        try {
          return await repository.getProductById(id);
        } catch (e) {
          // Log and skip
          print('Failed to load compare product $id: $e');
          return null;
        }
      }),
    );

    final products = results.whereType<ProductDetailPayload>().toList();
    if (products.isEmpty) {
      throw Exception('No compare products could be loaded');
    }

    return CompareProductsState(products: products);
  },
);
