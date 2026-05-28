import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/products_repository.dart';
import '../../domain/product_benchmark_model.dart';
import '../../domain/product_config_option_model.dart';
import '../../domain/product_model.dart';
import '../../domain/product_spec_model.dart';
import 'products_provider.dart';

class ProductDetailState {
	final ProductModel product;
	final List<ProductSpecModel> specs;
	final List<ProductBenchmarkModel> benchmarks;
	final List<ProductConfigOptionModel> configOptions;
	final List<ProductMediaItem> media;
	final List<ReviewModel> reviews;
	final Map<String, ProductConfigOptionModel> selectedOptions;

	const ProductDetailState({
		required this.product,
		required this.specs,
		required this.benchmarks,
		required this.configOptions,
		required this.media,
		required this.reviews,
		required this.selectedOptions,
	});

	ProductDetailState copyWith({
		ProductModel? product,
		List<ProductSpecModel>? specs,
		List<ProductBenchmarkModel>? benchmarks,
		List<ProductConfigOptionModel>? configOptions,
		List<ProductMediaItem>? media,
		List<ReviewModel>? reviews,
		Map<String, ProductConfigOptionModel>? selectedOptions,
	}) {
		return ProductDetailState(
			product: product ?? this.product,
			specs: specs ?? this.specs,
			benchmarks: benchmarks ?? this.benchmarks,
			configOptions: configOptions ?? this.configOptions,
			media: media ?? this.media,
			reviews: reviews ?? this.reviews,
			selectedOptions: selectedOptions ?? this.selectedOptions,
		);
	}
}

final productDetailProvider = AsyncNotifierProvider.family<
		ProductDetailNotifier, ProductDetailState, String>(
	ProductDetailNotifier.new,
);

class ProductDetailNotifier
    extends FamilyAsyncNotifier<ProductDetailState, String> {
  late final ProductsRepository _repository;

	@override
	Future<ProductDetailState> build(String productId) async {
		_repository = ref.read(productsRepositoryProvider);
		final payload = await _repository.getProductById(productId);
		return ProductDetailState(
			product: payload.product,
			specs: payload.specs,
			benchmarks: payload.benchmarks,
			configOptions: payload.configOptions,
			media: payload.media,
			reviews: payload.reviews,
			selectedOptions: _defaultSelectedOptions(payload.configOptions),
		);
	}

	void selectOption(ProductConfigOptionModel option) {
		final current = state.value;
		if (current == null) return;

		final updated = Map<String, ProductConfigOptionModel>.from(
			current.selectedOptions,
		);
		updated[option.optionGroup] = option;
		state = AsyncData(current.copyWith(selectedOptions: updated));
	}

	Map<String, ProductConfigOptionModel> _defaultSelectedOptions(
		List<ProductConfigOptionModel> options,
	) {
		final Map<String, ProductConfigOptionModel> selected = {};
		for (final option in options) {
			final group = option.optionGroup;
			if (!selected.containsKey(group) || option.isDefault) {
				selected[group] = option;
			}
		}
		return selected;
	}
}
