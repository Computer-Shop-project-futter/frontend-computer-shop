// lib/features/products/data/products_repository_hybrid.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'products_repository_supabase.dart';
import 'products_repository_sqlite.dart';
import 'products_repository.dart';
import '../domain/product_model.dart';

class ProductsRepositoryHybrid {
  final ProductsRepositorySupabase _api;
  final ProductsRepositorySQLite _local;
  final Connectivity _connectivity;
  
  bool _isOnline = true;
  final StreamController<bool> _onlineStatusController = StreamController.broadcast();
  Stream<bool> get onlineStatusStream => _onlineStatusController.stream;

  ProductsRepositoryHybrid({
    ProductsRepositorySupabase? api,
    ProductsRepositorySQLite? local,
  }) : _api = api ?? ProductsRepositorySupabase(),
       _local = local ?? ProductsRepositorySQLite(),
       _connectivity = Connectivity() {
    _initConnectivity();
    _listenToConnectivity();
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
    _onlineStatusController.add(_isOnline);
  }

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((results) {
      final newStatus = results != ConnectivityResult.none;
      if (_isOnline != newStatus) {
        _isOnline = newStatus;
        _onlineStatusController.add(_isOnline);
        if (_isOnline) {
          _syncPendingOperations();
        }
      }
    });
  }

  Future<PaginatedProducts> getProducts(
    ProductFilters filters, {
    int page = 1,
    bool forceRefresh = false,
  }) async {
    // If online and (force refresh OR cache is old/empty)
    if (_isOnline && (forceRefresh || !await _local.hasValidCache())) {
      try {
        final result = await _api.getProducts(filters, page: page);
        // Cache results
        await _local.cacheProducts(result.items, page: page);
        return result;
      } catch (e) {
        print('API error, falling back to cache: $e');
        // Fall back to cache if API fails
        final cached = await _local.getCachedProducts(filters: filters, page: page);
        return PaginatedProducts(
          items: cached,
          page: page,
          hasMore: cached.length == 20,
        );
      }
    }
    
    // Offline or cache is fresh - serve from cache
    final cached = await _local.getCachedProducts(filters: filters, page: page);
    return PaginatedProducts(
      items: cached,
      page: page,
      hasMore: cached.length == 20,
    );
  }

  Future<ProductDetailPayload> getProductById(String productId) async {
    // Try cache first (offline-first)
    final cached = await _local.getCachedProductDetail(productId);
    if (cached != null && !await _needsRefresh(productId)) {
      return cached;
    }
    
    // If online, fetch from API and update cache
    if (_isOnline) {
      try {
        final result = await _api.getProductById(productId);
        await _local.cacheProductDetail(result);
        return result;
      } catch (e) {
        if (cached != null) return cached;
        rethrow;
      }
    }
    
    if (cached != null) return cached;
    throw Exception('No internet connection and no cached data');
  }

  Future<bool> _needsRefresh(String productId) async {
    // Check if cached data is older than 24 hours
    final cached = await _local.getCachedProductDetail(productId);
    if (cached == null) return true;
    
    // If we have cached data, we consider it fresh for now
    // In production, you'd check timestamps from the database
    return false;
  }

  Future<void> _syncPendingOperations() async {
    // Sync any pending write operations when back online
    print('🔄 Syncing pending operations with Supabase...');
    // Implement sync logic for cart, wishlist, builds, etc.
  }

  Future<PaginatedProducts> getFeaturedProducts({int page = 1}) async {
    if (_isOnline) {
      try {
        final result = await _api.getFeaturedProducts(page: page);
        await _local.cacheProducts(result.items);
        return result;
      } catch (e) {
        final cached = await _local.getCachedProducts();
        return PaginatedProducts(items: cached, page: page, hasMore: false);
      }
    }
    final cached = await _local.getCachedProducts();
    return PaginatedProducts(items: cached, page: page, hasMore: false);
  }

  Future<PaginatedProducts> getDeals({int page = 1}) async {
    if (_isOnline) {
      try {
        final result = await _api.getDealProducts(page: page);
        await _local.cacheProducts(result.items);
        return result;
      } catch (e) {
        final cached = await _local.getCachedProducts();
        return PaginatedProducts(items: cached, page: page, hasMore: false);
      }
    }
    final cached = await _local.getCachedProducts();
    return PaginatedProducts(items: cached, page: page, hasMore: false);
  }

  bool get isOnline => _isOnline;
  
  void dispose() {
    _onlineStatusController.close();
  }
}