// lib/features/products/data/products_repository_sqlite.dart

import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_service.dart';
import '../domain/product_model.dart';
import '../domain/product_spec_model.dart';
import '../domain/product_benchmark_model.dart';
import '../domain/product_config_option_model.dart';
import 'products_repository.dart';

class ProductsRepositorySQLite {
  static const String _productsTable = 'products';
  static const String _specsTable = 'product_specs';
  static const String _benchmarksTable = 'product_benchmarks';
  static const String _configOptionsTable = 'product_config_options';
  static const String _mediaTable = 'product_media';
  static const String _reviewsTable = 'reviews';
  
  static const int _cacheDuration = 86400000; // 24 hours

  Future<Database> get _db async => await DatabaseService().database;

  Future<void> cacheProducts(List<ProductModel> products, {int? page}) async {
    final db = await _db;
    final batch = db.batch();
    
    for (final product in products) {
      batch.insert(
        _productsTable,
        {
          ...product.toMap(),
          'cached_at': DateTime.now().millisecondsSinceEpoch,
          'page': page ?? 1,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  Future<void> cacheProductDetail(ProductDetailPayload payload) async {
    final db = await _db;
    final batch = db.batch();
    
    batch.insert(
      _productsTable,
      payload.product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    for (final spec in payload.specs) {
      batch.insert(_specsTable, spec.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    for (final benchmark in payload.benchmarks) {
      batch.insert(_benchmarksTable, benchmark.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    for (final option in payload.configOptions) {
      batch.insert(_configOptionsTable, option.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    for (final media in payload.media) {
      batch.insert(_mediaTable, media.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    for (final review in payload.reviews) {
      batch.insert(_reviewsTable, review.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    await batch.commit(noResult: true);
  }

  Future<List<ProductModel>> getCachedProducts({
    ProductFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    final db = await _db;
    
    String whereClause = 'cached_at > ?';
    final whereArgs = <Object>[DateTime.now().millisecondsSinceEpoch - _cacheDuration];
    
    if (filters != null) {
      if (filters.featuredOnly) {
        whereClause += ' AND is_featured = 1';
      }
      if (filters.dealOnly) {
        whereClause += ' AND is_deal = 1';
      }
      if (filters.minPrice != null) {
        whereClause += ' AND base_price >= ?';
        whereArgs.add(filters.minPrice!);
      }
      if (filters.maxPrice != null) {
        whereClause += ' AND base_price <= ?';
        whereArgs.add(filters.maxPrice!);
      }
    }
    
    final results = await db.query(
      _productsTable,
      where: whereClause,
      whereArgs: whereArgs,
      limit: limit,
      offset: (page - 1) * limit,
    );
    
    return results.map((row) => ProductModel.fromMap(row)).toList();
  }

  Future<ProductDetailPayload?> getCachedProductDetail(String productId) async {
    final db = await _db;
    
    final productResult = await db.query(
      _productsTable,
      where: 'product_id = ? AND cached_at > ?',
      whereArgs: [productId, DateTime.now().millisecondsSinceEpoch - _cacheDuration],
    );
    
    if (productResult.isEmpty) return null;
    
    final product = ProductModel.fromMap(productResult.first);
    
    final specs = await db.query(_specsTable, where: 'product_id = ?', whereArgs: [productId]);
    final benchmarks = await db.query(_benchmarksTable, where: 'product_id = ?', whereArgs: [productId]);
    final configOptions = await db.query(_configOptionsTable, where: 'product_id = ?', whereArgs: [productId]);
    final media = await db.query(_mediaTable, where: 'product_id = ?', whereArgs: [productId]);
    final reviews = await db.query(_reviewsTable, where: 'product_id = ?', whereArgs: [productId]);
    
    return ProductDetailPayload(
      product: product,
      specs: specs.map((s) => ProductSpecModel.fromMap(s)).toList(),
      benchmarks: benchmarks.map((b) => ProductBenchmarkModel.fromMap(b)).toList(),
      configOptions: configOptions.map((c) => ProductConfigOptionModel.fromMap(c)).toList(),
      media: media.map((m) => ProductMediaItem.fromMap(m)).toList(),
      reviews: reviews.map((r) => ReviewModel.fromMap(r)).toList(),
    );
  }

  Future<bool> hasValidCache() async {
    final db = await _db;
    final result = await db.query(
      _productsTable,
      where: 'cached_at > ?',
      whereArgs: [DateTime.now().millisecondsSinceEpoch - _cacheDuration],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> clearCache() async {
    final db = await _db;
    await db.delete(_productsTable);
    await db.delete(_specsTable);
    await db.delete(_benchmarksTable);
    await db.delete(_configOptionsTable);
    await db.delete(_mediaTable);
    await db.delete(_reviewsTable);
  }
}