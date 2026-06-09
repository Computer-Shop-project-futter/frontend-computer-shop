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
    final results = await Future.wait(
      request.productIds.map(repository.getProductById),
    );

    return CompareProductsState(products: results);
  },
);
