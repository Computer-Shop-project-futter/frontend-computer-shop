// lib/features/pc_builder/data/builder_repository_hybrid.dart

import 'package:flutter/foundation.dart';
import '../domain/builder_model.dart';
import 'builder_repository.dart';
import 'builder_repository_sqlite.dart';
import 'builder_repository_supabase.dart';
import '../../../core/repositories/base_repository.dart';

/// Hybrid builder repository using SQLite locally with sync support
class BuilderRepositoryHybrid extends BaseRepository {
  final BuilderRepositorySQLite _sqlite;
  final BuilderRepository _mock;
  final BuilderRepositorySupabase _supabase;
  final List<BuildConfiguration> _webSavedBuilds = [];
  bool _isOnline = true;

  BuilderRepositoryHybrid({
    BuilderRepositorySQLite? sqlite,
    BuilderRepository? mock,
    BuilderRepositorySupabase? supabase,
  })  : _sqlite = sqlite ?? BuilderRepositorySQLite(),
        _mock = mock ?? BuilderRepository(),
        _supabase = supabase ?? BuilderRepositorySupabase();

  /// Get saved PC builds from local storage
  Future<List<BuildConfiguration>> getSavedBuilds({String? userId}) async {
    try {
      if (kIsWeb) {
        print('DEBUG: Fetching builds from web storage (${_webSavedBuilds.length} builds)');
        return List.unmodifiable(_webSavedBuilds);
      }
      
      print('DEBUG: Fetching builds from SQLite (userId: ${userId ?? "all"})');
      final builds = await _sqlite.getSavedBuilds(userId: userId);
      print('INFO: Retrieved ${builds.length} builds from SQLite');
      return builds;
    } catch (e) {
      print('ERROR: Failed to fetch saved builds: $e');
      rethrow;
    }
  }

  /// Save a new PC build locally
  Future<BuildConfiguration> saveBuild(
    BuildConfiguration build, {
    String? userId,
  }) async {
    try {
      if (kIsWeb) {
        print('DEBUG: Saving build to web storage - ID: ${build.id}');
        _webSavedBuilds.add(build);
        print('INFO: Build saved to web storage');
        return build;
      }

      print('DEBUG: Saving build to SQLite (hybrid mode, online: $_isOnline)');
      
      // Save locally first
      final saved = await _sqlite.saveBuild(build, userId: userId);
      print('INFO: Build saved to local SQLite database');

      // Queue for remote sync
      await addToSyncQueue(
        operation: 'INSERT',
        tableName: 'build_configurations',
        data: {
          'build_id': build.id,
          'name': build.name,
          'created_at': build.createdAt.millisecondsSinceEpoch,
          'cpu_id': build.cpu?.id,
          'gpu_id': build.gpu?.id,
          'motherboard_id': build.motherboard?.id,
          'ram_id': build.ram?.id,
          'storage_id': build.storage?.id,
          'cooling_id': build.cooling?.id,
          'psu_id': build.psu?.id,
          'case_id': build.pcCase?.id,
        },
      );
      print('DEBUG: Added to sync queue for remote sync');

      if (_isOnline) {
        try {
          print('DEBUG: Attempting online sync to Supabase');
          await _supabase.saveBuild(saved, userId: userId);
          print('INFO: Build synced to Supabase successfully');
        } catch (e) {
          print('WARNING: Online sync failed for save, will retry later: $e');
        }
      } else {
        print('INFO: Offline mode - build queued for sync when online');
      }

      return saved;
    } catch (e) {
      print('ERROR: Failed to save build: $e');
      rethrow;
    }
  }

  /// Delete a PC build
  Future<void> deleteBuild(String buildId) async {
    try {
      if (kIsWeb) {
        print('DEBUG: Deleting build from web storage - ID: $buildId');
        _webSavedBuilds.removeWhere((build) => build.id == buildId);
        print('INFO: Build deleted from web storage');
        return;
      }

      print('DEBUG: Deleting build from SQLite (online: $_isOnline)');
      await _sqlite.deleteBuild(buildId);
      print('INFO: Build deleted from local SQLite database');

      await addToSyncQueue(
        operation: 'DELETE',
        tableName: 'build_configurations',
        data: {'build_id': buildId},
      );
      print('DEBUG: Added to sync queue for remote deletion');

      if (_isOnline) {
        try {
          print('DEBUG: Attempting online sync for deletion');
          await _supabase.deleteBuild(buildId);
          print('INFO: Build deletion synced to Supabase successfully');
        } catch (e) {
          print('WARNING: Online sync failed for delete, will retry later: $e');
        }
      } else {
        print('INFO: Offline mode - deletion queued for sync when online');
      }
    } catch (e) {
      print('ERROR: Failed to delete build: $e');
      rethrow;
    }
  }

  /// Get specific build by ID
  Future<BuildConfiguration?> getBuild(String buildId) async {
    if (kIsWeb) {
      final index = _webSavedBuilds.indexWhere((build) => build.id == buildId);
      return index >= 0 ? _webSavedBuilds[index] : null;
    }
    return await _sqlite.getBuild(buildId);
  }

  /// Get available components by type (from mock data for now)
  Future<List<Component>> getComponentsByType(
    ComponentType type, {
    CpuBrand? brand,
  }) async {
    // Use mock repository for component catalog
    return await _mock.getComponentsByType(type, brand: brand);
  }

  /// Set online status
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
}
