// lib/core/services/app_lifecycle_manager.dart

import 'package:flutter/widgets.dart';
import 'offline_sync_service.dart';

class AppLifecycleManager extends WidgetsBindingObserver {
  final OfflineSyncService _syncService = OfflineSyncService();
  
  /// Track if app is in background
  bool _isInBackground = false;
  
  /// Track last sync time
  DateTime? _lastSyncTime;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _onAppResumed() {
    debugPrint('🟢 App resumed from background');
    _isInBackground = false;
    
    // Check if sync is needed (e.g., every 15 minutes)
    final shouldSync = _lastSyncTime == null || 
        DateTime.now().difference(_lastSyncTime!) > const Duration(minutes: 15);
    
    if (shouldSync) {
      _syncService.forceSync().then((result) {
        _lastSyncTime = DateTime.now();
        if (result.successCount > 0) {
          debugPrint('✅ Synced ${result.successCount} items on resume');
        }
      });
    }
  }

  void _onAppInactive() {
    debugPrint('🟡 App inactive');
    // App is about to become inactive (e.g., multitasking view)
  }

  void _onAppPaused() {
    debugPrint('🔴 App paused (background)');
    _isInBackground = true;
    
    // Stop periodic sync when in background to save battery
    _syncService.stopPeriodicSync();
  }

  void _onAppDetached() {
    debugPrint('⚫ App detached (terminating)');
    _syncService.dispose();
  }

  /// Check if app is currently in background
  bool get isInBackground => _isInBackground;
}