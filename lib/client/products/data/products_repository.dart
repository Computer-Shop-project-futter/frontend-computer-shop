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
	Future<PaginatedProducts> getProducts(ProductFilters filters, {int page = 1}) async {
		await Future.delayed(const Duration(milliseconds: 800));
		return PaginatedProducts(
			items: [
				ProductModel(
					productId: '1',
					name: 'Gaming Laptop',
					shortDescription: 'High performance gaming laptop',
					basePrice: 1299.99,
					categoryId: 'laptops',
					brandId: 'brand1',
					thumbnailUrl: '',
					isFeatured: true,
					isDeal: false,
					dealPrice: null,
					isActive: true,
				),
				ProductModel(
					productId: '2',
					name: 'Mechanical Keyboard',
					shortDescription: 'RGB Mechanical Keyboard',
					basePrice: 199.99,
					categoryId: 'peripherals',
					brandId: 'brand2',
					thumbnailUrl: '',
					isFeatured: false,
					isDeal: true,
					dealPrice: 149.99,
					isActive: true,
				),
			],
			page: page,
			hasMore: false,
		);
	}

	Future<ProductDetailPayload> getProductById(String productId) async {
		await Future.delayed(const Duration(milliseconds: 800));
		return ProductDetailPayload(
			product: ProductModel(
				productId: productId,
				name: 'Sample Product',
				shortDescription: 'This is a sample product',
				basePrice: 99.99,
				categoryId: 'category1',
				brandId: 'brand1',
				thumbnailUrl: '',
				isFeatured: false,
				isDeal: false,
				dealPrice: null,
				isActive: true,
			),
			specs: [],
			benchmarks: [],
			configOptions: [],
			media: [],
			reviews: [],
		);
	}
}
