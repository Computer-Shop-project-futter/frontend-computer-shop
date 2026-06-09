// lib/features/builder/data/builder_repository_sqlite.dart

import 'package:sqflite/sqlite_api.dart';
import '../../../core/repositories/base_repository.dart';
import '../domain/builder_model.dart';

class BuilderRepositorySQLite extends BaseRepository {
  static const String _buildsTable = 'build_configurations';

  Future<List<BuildConfiguration>> getSavedBuilds({String? userId}) async {
    final db = await database;
    
    final results = await db.query(
      _buildsTable,
      where: userId != null ? 'user_id = ?' : null,
      whereArgs: userId != null ? [userId] : null,
      orderBy: 'created_at DESC',
    );
    
    return results.map((row) => BuildConfiguration.fromDbJson(row)).toList();
  }

  Future<BuildConfiguration> saveBuild(BuildConfiguration build, {String? userId}) async {
    final db = await database;
    
    await db.insert(
      _buildsTable,
      {
        ...build.toDbJson(),
        'user_id': userId ?? 'current_user',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return build;
  }

  Future<void> deleteBuild(String buildId) async {
    final db = await database;
    await db.delete(_buildsTable, where: 'build_id = ?', whereArgs: [buildId]);
  }

  Future<BuildConfiguration?> getBuild(String buildId) async {
    final db = await database;
    final result = await db.query(
      _buildsTable,
      where: 'build_id = ?',
      whereArgs: [buildId],
    );
    
    if (result.isEmpty) return null;
    return BuildConfiguration.fromDbJson(result.first);
  }

  Future<List<Component>> getComponentsByType(
    ComponentType type, {
    CpuBrand? brand,
  }) async {
    // For components, we can either:
    // 1. Store them in a separate table
    // 2. Fetch from API with caching
    // For now, return mock data
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockComponentsByType(type, brand: brand);
  }

  List<Component> _getMockComponentsByType(ComponentType type, {CpuBrand? brand}) {
    // Mock implementation
    return [];
  }
}