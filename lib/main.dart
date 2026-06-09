// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/supabase/supabase_client.dart';
import './app/app.dart';
import './core/services/offline_sync_service.dart';
import './core/services/app_lifecycle_manager.dart';
import './core/database/database_service.dart';

/// Global navigator key for accessing context outside of widgets
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase initialization
  await SupabaseClientService().initialize();
  
  // Initialize database (skip on web)
  await _initializeDatabase();
  
  // Initialize offline sync service
  await _initializeOfflineSync();
  
  // Add lifecycle observer
  _setupLifecycleObserver();

  // Attach Flutter error handler
  FlutterError.onError = _handleFlutterError;
  
  // Run the app
  runApp(const ProviderScope(child: AppWidget()));
}

/// Initialize database with migrations if needed
Future<void> _initializeDatabase() async {
  try {
    // Initialize database service (creates tables if not exists)
    // This is skipped on web platform (sqflite not available)
    await DatabaseService().database;
    debugPrint('✅ Database initialized successfully');
  } catch (e) {
    // On web, database initialization will fail gracefully
    // The app will use Supabase as the primary backend
    if (e.toString().contains('databaseFactory') || e.toString().contains('web')) {
      debugPrint('ℹ️ Running on web - using Supabase as primary backend');
    } else {
      debugPrint('⚠️ Database initialization error: $e');
    }
  }
}

/// Initialize offline sync service
Future<void> _initializeOfflineSync() async {
  try {
    await OfflineSyncService().initialize();
    debugPrint('✅ Offline sync service initialized');
  } catch (e) {
    debugPrint('❌ Offline sync initialization failed: $e');
  }
}

/// Setup app lifecycle observer
void _setupLifecycleObserver() {
  // Add observer for app lifecycle events
  WidgetsBinding.instance.addObserver(AppLifecycleManager());
  debugPrint('✅ Lifecycle observer registered');
}

/// Custom error handling for Flutter framework
void _handleFlutterError(FlutterErrorDetails details) {
  // Log to crash reporting service
  debugPrint('Flutter Error: ${details.exception}');
  debugPrint('Stack trace: ${details.stack}');
  
  // You can send to analytics/crash reporting here
  // e.g., Crashlytics.instance.recordFlutterError(details);
  
  // Allow framework to handle normally
  FlutterError.presentError(details);
}