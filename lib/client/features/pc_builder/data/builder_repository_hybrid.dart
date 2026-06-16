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
    if (kIsWeb) {
      return List.unmodifiable(_webSavedBuilds);
    }
    return await _sqlite.getSavedBuilds(userId: userId);
  }

  /// Save a new PC build locally
  Future<BuildConfiguration> saveBuild(
    BuildConfiguration build, {
    String? userId,
  }) async {
    if (kIsWeb) {
      _webSavedBuilds.add(build);
      return build;
    }

    // Save locally first
    final saved = await _sqlite.saveBuild(build, userId: userId);

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

    if (_isOnline) {
      try {
        await _supabase.saveBuild(saved, userId: userId);
      } catch (e) {
        debugPrint('Build sync save failed, queued for later: $e');
      }
    }

    return saved;
  }

  /// Delete a PC build
  Future<void> deleteBuild(String buildId) async {
    if (kIsWeb) {
      _webSavedBuilds.removeWhere((build) => build.id == buildId);
      return;
    }

    await _sqlite.deleteBuild(buildId);

    await addToSyncQueue(
      operation: 'DELETE',
      tableName: 'build_configurations',
      data: {'build_id': buildId},
    );

    if (_isOnline) {
      try {
        await _supabase.deleteBuild(buildId);
      } catch (e) {
        debugPrint('Build sync delete failed, queued for later: $e');
      }
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
