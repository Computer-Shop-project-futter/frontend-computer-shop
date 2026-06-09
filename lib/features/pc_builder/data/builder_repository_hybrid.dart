// lib/features/pc_builder/data/builder_repository_hybrid.dart

import '../domain/builder_model.dart';
import 'builder_repository.dart';
import 'builder_repository_sqlite.dart';
import '../../../core/repositories/base_repository.dart';

/// Hybrid builder repository using SQLite locally with sync support
class BuilderRepositoryHybrid extends BaseRepository {
  final BuilderRepositorySQLite _sqlite;
  final BuilderRepository _mock;
  bool _isOnline = true;

  BuilderRepositoryHybrid({
    BuilderRepositorySQLite? sqlite,
    BuilderRepository? mock,
  })  : _sqlite = sqlite ?? BuilderRepositorySQLite(),
        _mock = mock ?? BuilderRepository();

  /// Get saved PC builds from local storage
  Future<List<BuildConfiguration>> getSavedBuilds({String? userId}) async {
    return await _sqlite.getSavedBuilds(userId: userId);
  }

  /// Save a new PC build locally
  Future<BuildConfiguration> saveBuild(
    BuildConfiguration build, {
    String? userId,
  }) async {
    // Save locally first
    final saved = await _sqlite.saveBuild(build, userId: userId);

    // Queue for remote sync
    if (_isOnline) {
      await addToSyncQueue(
        operation: 'INSERT',
        tableName: 'build_configurations',
        data: {
          'build_id': build.id,
          'name': build.name,
          'created_at': build.createdAt.millisecondsSinceEpoch,
          'cpu_id': build.cpu?.id,
          'gpu_id': build.gpu?.id,
          'storage_id': build.storage?.id,
          'total_price': build.totalPrice,
        },
      );
    }

    return saved;
  }

  /// Delete a PC build
  Future<void> deleteBuild(String buildId) async {
    await _sqlite.deleteBuild(buildId);

    // Queue for sync
    if (_isOnline) {
      await addToSyncQueue(
        operation: 'DELETE',
        tableName: 'build_configurations',
        data: {'build_id': buildId},
      );
    }
  }

  /// Get specific build by ID
  Future<BuildConfiguration?> getBuild(String buildId) async {
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
