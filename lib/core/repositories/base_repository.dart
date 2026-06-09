// lib/core/repositories/base_repository.dart

import 'package:sqflite/sqflite.dart';
import '../database/database_service.dart';

abstract class BaseRepository {
  Future<Database> get database async => await DatabaseService().database;

  /// Cache paginated API results
  Future<void> cachePaginatedResults<T>({
    required String cacheKey,
    required List<T> items,
    required Map<String, dynamic> Function(T) toJson,
    required String tableName,
    int page = 1,
    int pageSize = 20,
  }) async {
    final db = await database;
    final batch = db.batch();
    
    // Clear old cache for this page
    await db.delete(
      tableName,
      where: 'cached_at < ? AND page = ?',
      whereArgs: [DateTime.now().millisecondsSinceEpoch - 3600000, page],
    );
    
    // Insert new items with cache metadata
    for (final item in items) {
      final json = toJson(item);
      batch.insert(
        tableName,
        {
          ...json,
          'cached_at': DateTime.now().millisecondsSinceEpoch,
          'page': page,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  /// Get cached paginated results
  Future<List<T>> getCachedResults<T>({
    required String tableName,
    required int page,
    required T Function(Map<String, dynamic>) fromJson,
    int pageSize = 20,
  }) async {
    final db = await database;
    final results = await db.query(
      tableName,
      where: 'page = ?',
      whereArgs: [page],
      orderBy: 'cached_at DESC',
      limit: pageSize,
    );
    
    return results.map((row) => fromJson(row)).toList();
  }

  /// Sync queue for offline operations
  Future<void> addToSyncQueue({
    required String operation,
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert(
      'sync_queue',
      {
        'operation_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'operation': operation,
        'table_name': tableName,
        'data': data.toString(),
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'synced': 0,
      },
    );
  }

  /// Process sync queue (call when online)
  Future<void> processSyncQueue() async {
    final db = await database;
    final pending = await db.query('sync_queue', where: 'synced = 0');
    
    for (final item in pending) {
      try {
        // Send to API endpoint
        // await api.sync(item['operation'], item['data']);
        await db.update(
          'sync_queue',
          {'synced': 1, 'synced_at': DateTime.now().millisecondsSinceEpoch},
          where: 'operation_id = ?',
          whereArgs: [item['operation_id']],
        );
      } catch (e) {
        // Log failure for retry
      }
    }
  }
}