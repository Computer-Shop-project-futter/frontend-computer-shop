// D:\Year4\semester2\Mobile apps\computer-shop\frontend\frontend-computer-shop\lib\core\database\database_service.dart

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('Local SQLite database is not available on web.');
    }

    final String path = join(await getDatabasesPath(), 'g14_tech.db');
    
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Products table
    await db.execute('''
      CREATE TABLE products (
        product_id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        brand_id TEXT NOT NULL,
        name TEXT NOT NULL,
        short_description TEXT NOT NULL,
        base_price REAL NOT NULL,
        deal_price REAL,
        thumbnail_url TEXT,
        is_featured INTEGER NOT NULL DEFAULT 0,
        is_deal INTEGER NOT NULL DEFAULT 0,
        is_active INTEGER NOT NULL DEFAULT 1,
        cached_at INTEGER NOT NULL DEFAULT 0,
        page INTEGER DEFAULT 1
      )
    ''');

    // Product specs table
    await db.execute('''
      CREATE TABLE product_specs (
        spec_id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        spec_key TEXT NOT NULL,
        spec_value TEXT NOT NULL,
        unit TEXT,
        cached_at INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
      )
    ''');

    // Product benchmarks table
    await db.execute('''
      CREATE TABLE product_benchmarks (
        benchmark_id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        metric_key TEXT NOT NULL,
        metric_value TEXT NOT NULL,
        bar_percent REAL NOT NULL,
        cached_at INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
      )
    ''');

    // Product config options table
    await db.execute('''
      CREATE TABLE product_config_options (
        option_id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        option_group TEXT NOT NULL,
        option_label TEXT NOT NULL,
        price_delta REAL NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        cached_at INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
      )
    ''');

    // Product media table
    await db.execute('''
      CREATE TABLE product_media (
        media_id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        url TEXT NOT NULL,
        is_video INTEGER NOT NULL DEFAULT 0,
        display_order INTEGER DEFAULT 0,
        cached_at INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
      )
    ''');

    // Reviews table
    await db.execute('''
      CREATE TABLE reviews (
        review_id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        author TEXT NOT NULL,
        rating REAL NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        cached_at INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
      )
    ''');

    // Wishlist items table
    await db.execute('''
      CREATE TABLE wishlist_items (
        item_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        product_id TEXT,
        build_id TEXT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        image_url TEXT,
        type TEXT NOT NULL,
        metadata TEXT,
        added_at INTEGER NOT NULL,
        cached_at INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Build configurations table
    await db.execute('''
      CREATE TABLE build_configurations (
        build_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        cpu_id TEXT,
        gpu_id TEXT,
        motherboard_id TEXT,
        ram_id TEXT,
        storage_id TEXT,
        cooling_id TEXT,
        psu_id TEXT,
        case_id TEXT,
        cached_at INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (cpu_id) REFERENCES products (product_id)
      )
    ''');

    // Cart items table
    await db.execute('''
      CREATE TABLE cart_items (
        cart_item_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        product_id TEXT,
        build_id TEXT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        variant TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        price REAL NOT NULL,
        image_url TEXT,
        added_at INTEGER NOT NULL,
        cached_at INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Sync queue table for offline operations
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operation_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        table_name TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0,
        synced_at INTEGER,
        retry_count INTEGER NOT NULL DEFAULT 0,
        last_error TEXT
      )
    ''');

    // Create indexes for performance
    await db.execute('CREATE INDEX idx_products_category ON products(category_id)');
    await db.execute('CREATE INDEX idx_products_featured ON products(is_featured)');
    await db.execute('CREATE INDEX idx_products_deal ON products(is_deal)');
    await db.execute('CREATE INDEX idx_products_cached ON products(cached_at)');
    await db.execute('CREATE INDEX idx_wishlist_user ON wishlist_items(user_id)');
    await db.execute('CREATE INDEX idx_builds_user ON build_configurations(user_id)');
    await db.execute('CREATE INDEX idx_cart_user ON cart_items(user_id)');
    await db.execute('CREATE INDEX idx_sync_synced ON sync_queue(synced, retry_count)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add cached_at column to existing tables if needed
      try {
        await db.execute('ALTER TABLE products ADD COLUMN cached_at INTEGER DEFAULT 0');
      } catch (e) {
        print('Column might already exist: $e');
      }
    }
  }

  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete('products');
    await db.delete('product_specs');
    await db.delete('product_benchmarks');
    await db.delete('product_config_options');
    await db.delete('product_media');
    await db.delete('reviews');
    print('✅ All cache cleared');
  }

  Future<int> getCacheSize() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    return result.first['count'] as int? ?? 0;
  }
}