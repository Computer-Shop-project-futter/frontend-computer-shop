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
      var query = _supabase.client.from('products').select('*');

      // Only show active products by default
      query = query.eq('is_active', true);

      if (filters.featuredOnly) {
        query = query.eq('is_featured', true);
      }
      if (filters.dealOnly) {
        query = query.eq('is_deal', true);
      }
      final minPrice = filters.minPrice;
      final maxPrice = filters.maxPrice;

      if (minPrice != null) {
        query = query.gte('base_price', minPrice);
      }
      if (maxPrice != null) {
        query = query.lte('base_price', maxPrice);
      }
      if (filters.categoryIds.isNotEmpty) {
        query = query.inFilter('category_id', filters.categoryIds);
      }
      if (filters.brandIds.isNotEmpty) {
        query = query.inFilter('brand_id', filters.brandIds);
      }
      final searchQuery = filters.searchQuery?.trim();
      if (searchQuery?.isNotEmpty == true) {
        query = query.or(
          'name.ilike.%$searchQuery%,short_description.ilike.%$searchQuery%',
        );
      }

      final data = await query
          .order('created_at', ascending: false)
          .range((page - 1) * pageSize, page * pageSize - 1) as List;

      final products = data
          .map((json) => ProductModel.fromDbJson(json as Map<String, dynamic>))
          .toList();
      final hasMore = products.length == pageSize;

      return PaginatedProducts(
        items: products,
        page: page,
        hasMore: hasMore,
      );
    } catch (e) {
      rethrow;
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
          .select('*')
          .eq('product_id', productId)
          .eq('is_active', true)
          .maybeSingle();

      if (productResponse == null) throw Exception('Product not found');
      final product = ProductModel.fromDbJson(productResponse);

      final specsData = await _supabase.client
          .from('product_specs')
          .select('*')
          .eq('product_id', productId)
          .order('display_order');
      final specs = (specsData as List)
          .map((json) => ProductSpecModel.fromJson(json as Map<String, dynamic>))
          .toList();

        final benchmarksData = await _supabase.client
          .from('product_benchmarks')
          .select('*')
          .eq('product_id', productId)
          .order('metric_key');
      final benchmarks = (benchmarksData as List)
          .map((json) => ProductBenchmarkModel.fromJson(json as Map<String, dynamic>))
          .toList();

        final configData = await _supabase.client
          .from('product_config_options')
          .select('*')
          .eq('product_id', productId)
          .order('option_label', ascending: true);
      final configOptions = (configData as List)
          .map((json) => ProductConfigOptionModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final mediaData = await _supabase.client
          .from('product_media')
          .select('*')
          .eq('product_id', productId)
          .order('display_order');
      final media = (mediaData as List)
          .map((json) => ProductMediaItem.fromMap(json as Map<String, dynamic>))
          .toList();

      final reviewsData = await _supabase.client
          .from('reviews')
          .select('*')
          .eq('product_id', productId)
          .order('created_at', ascending: false);
      final reviews = (reviewsData as List)
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
      rethrow;
    }
  }

  /// Create a new product (admin operation)
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await _supabase.client
          .from('products')
          .insert(product.toDbJson())
          .select('*')
          .single();

      return ProductModel.fromDbJson(response);
    } catch (e) {
      rethrow;
    }
  }
}