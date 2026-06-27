// lib/core/services/sync_service.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/database_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  SyncService._internal();
  factory SyncService() => _instance;

  final _pendingOperations = <Map<String, dynamic>>[];
  bool _isSyncing = false;

  Future<void> addPendingOperation(Map<String, dynamic> operation) async {
    final db = await DatabaseService().database;
    await db.insert('sync_queue', {
      'operation': operation['type'],
      'table': operation['table'],
      'data': operation['data'].toString(),
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'synced': 0,
    });
    
    // Trigger sync if online
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      syncNow();
    }
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;
    
    final db = await DatabaseService().database;
    final pending = await db.query('sync_queue', where: 'synced = 0');
    
    for (final op in pending) {
      try {
        // Send to Supabase based on operation type
        // await _sendToSupabase(op);
        
        await db.update(
          'sync_queue',
          {'synced': 1, 'synced_at': DateTime.now().millisecondsSinceEpoch},
          where: 'id = ?',
          whereArgs: [op['id']],
        );
      } catch (e) {
        print('Sync failed: $e');
      }
    }
    
    _isSyncing = false;
  }
}