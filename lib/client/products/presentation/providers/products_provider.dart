import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/products_repository.dart';
import '../../domain/product_model.dart';

class ProductsState {
	final List<ProductModel> items;
	final int page;
	final bool hasMore;
	final ProductFilters filters;
	final bool isLoadingMore;

	const ProductsState({
		required this.items,
		required this.page,
		required this.hasMore,
		required this.filters,
		required this.isLoadingMore,
	});

	ProductsState copyWith({
		List<ProductModel>? items,
		int? page,
		bool? hasMore,
		ProductFilters? filters,
		bool? isLoadingMore,
	}) {
		return ProductsState(
			items: items ?? this.items,
			page: page ?? this.page,
			hasMore: hasMore ?? this.hasMore,
			filters: filters ?? this.filters,
			isLoadingMore: isLoadingMore ?? this.isLoadingMore,
		);
	}
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
	return ProductsRepository();
});

final productsProvider = AsyncNotifierProvider<ProductsNotifier, ProductsState>(
	ProductsNotifier.new,
);

class ProductsNotifier extends AsyncNotifier<ProductsState> {
	late final ProductsRepository _repository;

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

	Future<void> loadMore() async {
		final current = state.value;
		if (current == null || current.isLoadingMore || !current.hasMore) {
			return;
		}

		state = AsyncData(current.copyWith(isLoadingMore: true));
		final nextPage = current.page + 1;
		final result = await _repository.getProducts(current.filters, page: nextPage);
		final updatedItems = [...current.items, ...result.items];
		state = AsyncData(current.copyWith(
			items: updatedItems,
			page: result.page,
			hasMore: result.hasMore,
			isLoadingMore: false,
		));
	}

	Future<void> applyFilter(ProductFilters filters) async {
		state = const AsyncLoading();
		final result = await _repository.getProducts(filters, page: 1);
		state = AsyncData(ProductsState(
			items: result.items,
			page: result.page,
			hasMore: result.hasMore,
			filters: filters,
			isLoadingMore: false,
		));
	}

	Future<void> resetFilters() async {
		await applyFilter(const ProductFilters());
	}
}
