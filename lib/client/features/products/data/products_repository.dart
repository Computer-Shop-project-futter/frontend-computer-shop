import '../../../core/repositories/base_repository.dart';
import '../domain/product_model.dart';
import '../domain/product_spec_model.dart';
import '../domain/product_benchmark_model.dart';
import '../domain/product_config_option_model.dart';

// Simple models and a default repository implementation used across the app.

class ProductFilters {
  final bool featuredOnly;
  final bool dealOnly;
  final bool inStockOnly;
  final double? minPrice;
  final double? maxPrice;
  final List<String> categoryIds;
  final List<String> brandIds;

  const ProductFilters({
    this.featuredOnly = false,
    this.dealOnly = false,
    this.inStockOnly = false,
    this.minPrice,
    this.maxPrice,
    this.categoryIds = const [],
    this.brandIds = const [],
  });

  ProductFilters copyWith({
    bool? featuredOnly,
    bool? dealOnly,
    bool? inStockOnly,
    double? minPrice,
    double? maxPrice,
    List<String>? categoryIds,
    List<String>? brandIds,
  }) {
    return ProductFilters(
      featuredOnly: featuredOnly ?? this.featuredOnly,
      dealOnly: dealOnly ?? this.dealOnly,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      categoryIds: categoryIds ?? this.categoryIds,
      brandIds: brandIds ?? this.brandIds,
    );
  }
}

class PaginatedProducts {
  final List<ProductModel> items;
  final int page;
  final bool hasMore;

  const PaginatedProducts({required this.items, required this.page, required this.hasMore});
}

class ProductMediaItem {
  final String url;
  final bool isVideo;

  const ProductMediaItem({required this.url, this.isVideo = false});

  factory ProductMediaItem.fromMap(Map<String, dynamic> map) {
    return ProductMediaItem(
      url: map['url']?.toString() ?? '',
      isVideo: (map['is_video'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() => {
        'url': url,
        'is_video': isVideo ? 1 : 0,
      };
}

class ReviewModel {
  final String author;
  final String title;
  final String body;
  final double rating;

  const ReviewModel({required this.author, required this.title, required this.body, required this.rating});

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      author: map['author']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'author': author,
        'title': title,
        'body': body,
        'rating': rating,
      };
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
    this.specs = const [],
    this.benchmarks = const [],
    this.configOptions = const [],
    this.media = const [],
    this.reviews = const [],
  });
}

/// Lightweight default repository used when no other implementation is provided.
class ProductsRepository extends BaseRepository {
  ProductsRepository();

  Future<PaginatedProducts> getProducts(ProductFilters filters, {int page = 1, bool forceRefresh = false}) async {
    return const PaginatedProducts(items: [], page: 1, hasMore: false);
  }

  Future<ProductDetailPayload> getProductById(String productId) async {
    // Return a minimal default payload so the app can compile and run in dev.
    final product = ProductModel(
      productId: productId,
      categoryId: '',
      brandId: '',
      name: 'Unknown Product',
      shortDescription: '',
      basePrice: 0,
      dealPrice: null,
      thumbnailUrl: '',
      isFeatured: false,
      isDeal: false,
      isActive: false,
    );

    return ProductDetailPayload(product: product);
  }
}

/// State class for products provider
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
