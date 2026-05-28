import 'package:dio/dio.dart';

import '../../core/config/api_config.dart';
import '../domain/product_benchmark_model.dart';
import '../domain/product_config_option_model.dart';
import '../domain/product_model.dart';
import '../domain/product_spec_model.dart';

class ProductFilters {
	final List<String> categoryIds;
	final List<String> brandIds;
	final double? minPrice;
	final double? maxPrice;
	final bool featuredOnly;
	final bool dealOnly;
	final bool inStockOnly;

	const ProductFilters({
		this.categoryIds = const [],
		this.brandIds = const [],
		this.minPrice,
		this.maxPrice,
		this.featuredOnly = false,
		this.dealOnly = false,
		this.inStockOnly = false,
	});

	ProductFilters copyWith({
		List<String>? categoryIds,
		List<String>? brandIds,
		double? minPrice,
		double? maxPrice,
		bool? featuredOnly,
		bool? dealOnly,
		bool? inStockOnly,
	}) {
		return ProductFilters(
			categoryIds: categoryIds ?? this.categoryIds,
			brandIds: brandIds ?? this.brandIds,
			minPrice: minPrice ?? this.minPrice,
			maxPrice: maxPrice ?? this.maxPrice,
			featuredOnly: featuredOnly ?? this.featuredOnly,
			dealOnly: dealOnly ?? this.dealOnly,
			inStockOnly: inStockOnly ?? this.inStockOnly,
		);
	}

	Map<String, dynamic> toQueryParameters({int? page}) {
		final params = <String, dynamic>{};
		if (categoryIds.isNotEmpty) {
			params['categoryIds'] = categoryIds;
		}
		if (brandIds.isNotEmpty) {
			params['brandIds'] = brandIds;
		}
		if (minPrice != null) {
			params['minPrice'] = minPrice;
		}
		if (maxPrice != null) {
			params['maxPrice'] = maxPrice;
		}
		if (featuredOnly) {
			params['featuredOnly'] = true;
		}
		if (dealOnly) {
			params['dealOnly'] = true;
		}
		if (inStockOnly) {
			params['inStockOnly'] = true;
		}
		if (page != null) {
			params['page'] = page;
		}
		return params;
	}
}

class PaginatedProducts {
	final List<ProductModel> items;
	final int page;
	final bool hasMore;

	const PaginatedProducts({
		required this.items,
		required this.page,
		required this.hasMore,
	});
}

class ProductMediaItem {
	final String url;
	final bool isVideo;

	const ProductMediaItem({
		required this.url,
		required this.isVideo,
	});

	factory ProductMediaItem.fromJson(Map<String, dynamic> json) {
		return ProductMediaItem(
			url: json['url']?.toString() ?? '',
			isVideo: json['isVideo'] == true,
		);
	}
}

class ReviewModel {
	final String reviewId;
	final String author;
	final double rating;
	final String title;
	final String body;

	const ReviewModel({
		required this.reviewId,
		required this.author,
		required this.rating,
		required this.title,
		required this.body,
	});

	factory ReviewModel.fromJson(Map<String, dynamic> json) {
		return ReviewModel(
			reviewId: json['reviewId']?.toString() ?? '',
			author: json['author']?.toString() ?? '',
			rating: (json['rating'] as num?)?.toDouble() ?? 0,
			title: json['title']?.toString() ?? '',
			body: json['body']?.toString() ?? '',
		);
	}
}

class ProductDetailPayload {
	final ProductModel product;
	final List<ProductSpecModel> specs;
	final List<ProductBenchmarkModel> benchmarks;
	final List<ProductConfigOptionModel> configOptions;
	final List<ProductMediaItem> media;
	final List<ReviewModel> reviews;

	const ProductDetailPayload({
		required this.product,
		required this.specs,
		required this.benchmarks,
		required this.configOptions,
		required this.media,
		required this.reviews,
	});
}

class ProductsRepository {
	ProductsRepository({Dio? dio})
			: _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

	final Dio _dio;

	Future<PaginatedProducts> getProducts(ProductFilters filters, {int page = 1}) async {
		final response = await _dio.get(
			'/products',
			queryParameters: filters.toQueryParameters(page: page),
		);

		final data = response.data;
		final items = _extractList(data).map(ProductModel.fromJson).toList();
		final pageValue = _extractInt(data, 'page') ?? page;
		final hasMore = _extractBool(data, 'hasMore') ?? false;
		return PaginatedProducts(
			items: items,
			page: pageValue,
			hasMore: hasMore,
		);
	}

	Future<ProductDetailPayload> getProductById(String productId) async {
		final response = await _dio.get('/products/$productId');
		final data = _extractMap(response.data);
		final productMap = _extractMap(data['product']);
		final product = ProductModel.fromJson(
			productMap.isNotEmpty ? productMap : data,
		);
		final specs = _extractList(data['specs'])
				.map(ProductSpecModel.fromJson)
				.toList();
		final benchmarks = _extractList(data['benchmarks'])
				.map(ProductBenchmarkModel.fromJson)
				.toList();
		final configOptions = _extractList(data['configOptions'])
				.map(ProductConfigOptionModel.fromJson)
				.toList();
		final media = _extractList(data['media'])
				.map(ProductMediaItem.fromJson)
				.toList();
		final reviews = _extractList(data['reviews'])
				.map(ReviewModel.fromJson)
				.toList();

		return ProductDetailPayload(
			product: product,
			specs: specs,
			benchmarks: benchmarks,
			configOptions: configOptions,
			media: media,
			reviews: reviews,
		);
	}

	List<Map<String, dynamic>> _extractList(dynamic data) {
		if (data is List) {
			return data.cast<Map<String, dynamic>>();
		}
		if (data is Map<String, dynamic> && data['data'] is List) {
			return (data['data'] as List).cast<Map<String, dynamic>>();
		}
		return const [];
	}

	Map<String, dynamic> _extractMap(dynamic data) {
		if (data is Map<String, dynamic>) {
			if (data['data'] is Map<String, dynamic>) {
				return data['data'] as Map<String, dynamic>;
			}
			return data;
		}
		return const {};
	}

	int? _extractInt(dynamic data, String key) {
		if (data is Map<String, dynamic> && data[key] is num) {
			return (data[key] as num).toInt();
		}
		if (data is Map<String, dynamic> && data['meta'] is Map) {
			final meta = data['meta'] as Map;
			final value = meta[key];
			if (value is num) return value.toInt();
		}
		return null;
	}

	bool? _extractBool(dynamic data, String key) {
		if (data is Map<String, dynamic> && data[key] is bool) {
			return data[key] as bool;
		}
		if (data is Map<String, dynamic> && data['meta'] is Map) {
			final meta = data['meta'] as Map;
			final value = meta[key];
			if (value is bool) return value;
		}
		return null;
	}
}
