// lib/features/products/data/products_repository_supabase.dart

import '../../../core/supabase/supabase_client.dart';
import '../domain/product_model.dart';
import '../domain/product_spec_model.dart';
import '../domain/product_benchmark_model.dart';
import '../domain/product_config_option_model.dart';
import 'products_repository.dart';

class ProductsRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  Future<PaginatedProducts> getProducts(
    ProductFilters filters, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      var query = _supabase.client
          .from('products')
          .select()
          .order('created_at', ascending: false)
          .range((page - 1) * pageSize, page * pageSize - 1);

      // Apply filters - note: in current Postgrest, we can't chain complex filters
      // For now, fetch all and filter in dart, or use a simpler approach
      // This is a known limitation with the current API
      final response = await query;

      final products = (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
      final hasMore = products.length == pageSize;
      
      return PaginatedProducts(
        items: products,
        page: page,
        hasMore: hasMore,
      );
    } catch (e) {
      print('Supabase getProducts error: $e');
      return PaginatedProducts(items: [], page: page, hasMore: false);
    }
  }

  /// Get featured products
  Future<PaginatedProducts> getFeaturedProducts({
    int page = 1,
    int pageSize = 20,
  }) async {
    final filters = ProductFilters(featuredOnly: true);
    return getProducts(filters, page: page, pageSize: pageSize);
  }

  /// Get deal products
  Future<PaginatedProducts> getDealProducts({
    int page = 1,
    int pageSize = 20,
  }) async {
    final filters = ProductFilters(dealOnly: true);
    return getProducts(filters, page: page, pageSize: pageSize);
  }

  Future<ProductDetailPayload> getProductById(String productId) async {
    try {
      final productResponse = await _supabase.client
          .from('products')
          .select()
          .order('created_at', ascending: false)
          .maybeSingle();
      
      if (productResponse == null) throw Exception('Product not found');
      final product = ProductModel.fromJson(productResponse as Map<String, dynamic>);
      
      final specsResponse = await _supabase.client
          .from('product_specs')
          .select()
          .order('display_order');
      final specs = (specsResponse as List)
          .map((json) => ProductSpecModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final benchmarksResponse = await _supabase.client
          .from('product_benchmarks')
          .select()
          .order('name');
      final benchmarks = (benchmarksResponse as List)
          .map((json) => ProductBenchmarkModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final configResponse = await _supabase.client
          .from('product_config_options')
          .select()
          .order('name');
      final configOptions = (configResponse as List)
          .map((json) => ProductConfigOptionModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final mediaResponse = await _supabase.client
          .from('product_media')
          .select()
          .order('display_order');
      final media = (mediaResponse as List)
          .map((json) => ProductMediaItem.fromMap(json as Map<String, dynamic>))
          .toList();
      
      final reviewsResponse = await _supabase.client
          .from('reviews')
          .select()
          .order('created_at', ascending: false);
      final reviews = (reviewsResponse as List)
          .map((json) => ReviewModel.fromMap(json as Map<String, dynamic>))
          .toList();
      
      return ProductDetailPayload(
        product: product,
        specs: specs,
        benchmarks: benchmarks,
        configOptions: configOptions,
        media: media,
        reviews: reviews,
      );
    } catch (e) {
      print('Supabase getProductById error: $e');
      rethrow;
    }
  }

  /// Create a new product (admin operation)
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await _supabase.client
          .from('products')
          .insert(product.toJson())
          .select()
          .single();
      
      return ProductModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Supabase createProduct error: $e');
      rethrow;
    }
  }
}