// lib/core/services/offline_sync_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/database_service.dart';

/// Offline sync service for managing local-first data synchronization
class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  Timer? _syncTimer;
  bool _isSyncing = false;
  final Connectivity _connectivity = Connectivity();
  final StreamController<SyncStatus> _syncStatusController = StreamController.broadcast();
  
  OfflineSyncService._internal();

  factory OfflineSyncService() => _instance;

  /// Stream to listen to sync status changes
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Initialize the sync service (call in main.dart)
  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('ℹ️ Offline sync disabled on web; using Supabase only.');
      return;
    }

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = results != ConnectivityResult.none;
      if (isConnected) {
        // Trigger sync when connection is restored
        syncPendingOperations();
      }
    });
    
    // Create sync_queue table if not exists
    await _ensureSyncQueueTable();
    
    // Start periodic sync
    startPeriodicSync();
  }

  /// Ensure sync_queue table exists
  Future<void> _ensureSyncQueueTable() async {
    final db = await DatabaseService().database;
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_queue (
        operation_id TEXT PRIMARY KEY,
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
    
    // Create index for faster queries
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_sync_queue_synced 
      ON sync_queue(synced, retry_count, created_at)
    ''');
  }

  /// Start periodic background sync
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (timer) async {
      final isConnected = await _checkConnectivity();
      if (isConnected) {
        await syncPendingOperations();
      }
    });
  }

  /// Stop periodic sync (call when app goes to background)
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Add operation to sync queue
  Future<void> addToSyncQueue({
    required String operation,
    required String tableName,
    required String entityId,
    required Map<String, dynamic> data,
  }) async {
    final db = await DatabaseService().database;
    
    // Check if already in queue (prevent duplicates)
    final existing = await db.query(
      'sync_queue',
      where: 'entity_id = ? AND operation = ? AND synced = 0',
      whereArgs: [entityId, operation],
    );
    
    if (existing.isNotEmpty) {
      // Update existing entry
      await db.update(
        'sync_queue',
        {
          'data': jsonEncode(data),
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'retry_count': 0,
        },
        where: 'operation_id = ?',
        whereArgs: [existing.first['operation_id']],
      );
      return;
    }
    
    await db.insert(
      'sync_queue',
      {
        'operation_id': '${DateTime.now().millisecondsSinceEpoch}_$entityId',
        'operation': operation,
        'table_name': tableName,
        'entity_id': entityId,
        'data': jsonEncode(data),
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'synced': 0,
        'retry_count': 0,
      },
    );
  }

  /// Remove operation from sync queue (for immediate syncs)
  Future<void> removeFromSyncQueue(String operationId) async {
    final db = await DatabaseService().database;
    await db.delete('sync_queue', where: 'operation_id = ?', whereArgs: [operationId]);
  }

  /// Sync all pending operations
  Future<SyncResult> syncPendingOperations() async {
    // Prevent multiple concurrent syncs
    if (_isSyncing) {
      return SyncResult(successCount: 0, failureCount: 0, isRunning: true);
    }
    
    _isSyncing = true;
    _syncStatusController.add(SyncStatus.started());
    
    int successCount = 0;
    int failureCount = 0;
    
    try {
      final isConnected = await _checkConnectivity();
      if (!isConnected) {
        _syncStatusController.add(SyncStatus.offline());
        _isSyncing = false;
        return SyncResult(successCount: 0, failureCount: 0, isOffline: true);
      }
      
      final db = await DatabaseService().database;
      
      // Get pending items with exponential backoff
      final pending = await db.query(
        'sync_queue',
        where: 'synced = 0 AND retry_count < 5',
        orderBy: 'retry_count ASC, created_at ASC',
        limit: 50,
      );
      
      if (pending.isEmpty) {
        _syncStatusController.add(SyncStatus.completed(successCount: 0));
        _isSyncing = false;
        return SyncResult(successCount: 0, failureCount: 0);
      }
      
      _syncStatusController.add(SyncStatus.progress(pending.length, 0));
      
      for (final item in pending) {
        try {
          final success = await _syncOperation(item);
          
          if (success) {
            // Mark as synced
            await db.update(
              'sync_queue',
              {
                'synced': 1,
                'synced_at': DateTime.now().millisecondsSinceEpoch,
              },
              where: 'operation_id = ?',
              whereArgs: [item['operation_id']],
            );
            successCount++;
          } else {
            // Increment retry count
            final newRetryCount = (item['retry_count'] as int) + 1;
            await db.update(
              'sync_queue',
              {
                'retry_count': newRetryCount,
                'last_error': 'Sync failed',
              },
              where: 'operation_id = ?',
              whereArgs: [item['operation_id']],
            );
            failureCount++;
          }
        } catch (e, stackTrace) {
          failureCount++;
          final newRetryCount = (item['retry_count'] as int) + 1;
          await db.update(
            'sync_queue',
            {
              'retry_count': newRetryCount,
              'last_error': e.toString(),
            },
            where: 'operation_id = ?',
            whereArgs: [item['operation_id']],
          );
          debugPrint('Sync error for ${item['operation_id']}: $e\n$stackTrace');
        }
        
        _syncStatusController.add(SyncStatus.progress(pending.length, successCount + failureCount));
      }
      
      // Clean up old successful syncs (older than 7 days)
      await _cleanupOldSyncs();
      
      _syncStatusController.add(SyncStatus.completed(successCount: successCount));
      return SyncResult(successCount: successCount, failureCount: failureCount);
      
    } catch (e) {
      _syncStatusController.add(SyncStatus.failed(e.toString()));
      return SyncResult(successCount: successCount, failureCount: failureCount, error: e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync a single operation to backend
  Future<bool> _syncOperation(Map<String, dynamic> item) async {
    final operation = item['operation'] as String;
    final tableName = item['table_name'] as String;
    final data = jsonDecode(item['data'] as String) as Map<String, dynamic>;
    
    // Route to appropriate API endpoint based on table
    switch (tableName) {
      case 'wishlist_items':
        return await _syncWishlistOperation(operation, data);
      case 'cart_items':
        return await _syncCartOperation(operation, data);
      case 'build_configurations':
        return await _syncBuildOperation(operation, data);
      case 'repair_requests':
        return await _syncRepairOperation(operation, data);
      default:
        return false;
    }
  }

  Future<bool> _syncWishlistOperation(String operation, Map<String, dynamic> data) async {
    // Simulate API call - replace with actual HTTP request
    await Future.delayed(const Duration(milliseconds: 200));
    
    switch (operation) {
      case 'INSERT':
        // POST /api/wishlist
        return true;
      case 'DELETE':
        // DELETE /api/wishlist/{id}
        return true;
      default:
        return false;
    }
  }

  Future<bool> _syncCartOperation(String operation, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    switch (operation) {
      case 'INSERT':
        // POST /api/cart
        return true;
      case 'UPDATE':
        // PUT /api/cart/{id}
        return true;
      case 'DELETE':
        // DELETE /api/cart/{id}
        return true;
      default:
        return false;
    }
  }

  Future<bool> _syncBuildOperation(String operation, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    switch (operation) {
      case 'INSERT':
        // POST /api/builds
        return true;
      case 'UPDATE':
        // PUT /api/builds/{id}
        return true;
      case 'DELETE':
        // DELETE /api/builds/{id}
        return true;
      default:
        return false;
    }
  }

  Future<bool> _syncRepairOperation(String operation, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    switch (operation) {
      case 'INSERT':
        // POST /api/repairs
        return true;
      default:
        return false;
    }
  }

  /// Clean up old synced records
  Future<void> _cleanupOldSyncs() async {
    final db = await DatabaseService().database;
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    
    await db.delete(
      'sync_queue',
      where: 'synced = 1 AND synced_at < ?',
      whereArgs: [sevenDaysAgo],
    );
  }

  /// Check connectivity
  Future<bool> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Get pending sync count
  Future<int> getPendingSyncCount() async {
    final db = await DatabaseService().database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue WHERE synced = 0');
    return result.first['count'] as int? ?? 0;
  }

  /// Force immediate sync (call when app comes to foreground)
  Future<SyncResult> forceSync() async {
    return await syncPendingOperations();
  }

  /// Dispose resources
  void dispose() {
    stopPeriodicSync();
    _syncStatusController.close();
  }
}

/// Sync status for UI updates
class SyncStatus {
  final SyncStatusType type;
  final int? totalItems;
  final int? processedItems;
  final int? successCount;
  final String? error;

  SyncStatus._({
    required this.type,
    this.totalItems,
    this.processedItems,
    this.successCount,
    this.error,
  });

  factory SyncStatus.started() => SyncStatus._(type: SyncStatusType.started);
  
  factory SyncStatus.progress(int total, int processed) => SyncStatus._(
    type: SyncStatusType.progress,
    totalItems: total,
    processedItems: processed,
  );
  
  factory SyncStatus.offline() => SyncStatus._(type: SyncStatusType.offline);
  
  factory SyncStatus.completed({int? successCount}) => SyncStatus._(
    type: SyncStatusType.completed,
    successCount: successCount,
  );
  
  factory SyncStatus.failed(String error) => SyncStatus._(
    type: SyncStatusType.failed,
    error: error,
  );

  bool get isStarted => type == SyncStatusType.started;
  bool get isProgress => type == SyncStatusType.progress;
  bool get isOffline => type == SyncStatusType.offline;
  bool get isCompleted => type == SyncStatusType.completed;
  bool get isFailed => type == SyncStatusType.failed;
  
  double get progressPercent {
    if (totalItems == null || processedItems == null || totalItems == 0) return 0;
    return processedItems! / totalItems!;
  }
}

enum SyncStatusType {
  started,
  progress,
  offline,
  completed,
  failed,
}

/// Sync result object
class SyncResult {
  final int successCount;
  final int failureCount;
  final bool isRunning;
  final bool isOffline;
  final String? error;

  SyncResult({
    this.successCount = 0,
    this.failureCount = 0,
    this.isRunning = false,
    this.isOffline = false,
    this.error,
  });

  bool get hasErrors => failureCount > 0 || error != null;
  bool get isSuccessful => successCount > 0 && failureCount == 0;
}