// lib/features/builder/data/builder_repository_sqlite.dart

import 'package:sqflite/sqlite_api.dart';
import '../../../core/repositories/base_repository.dart';
import '../domain/builder_model.dart';

class BuilderRepositorySQLite extends BaseRepository {
  static const String _buildsTable = 'build_configurations';

  Future<List<BuildConfiguration>> getSavedBuilds({String? userId}) async {
    try {
      print('DEBUG: Fetching saved builds for user: ${userId ?? "all"}');
      final db = await database;
      
      final results = await db.query(
        _buildsTable,
        where: userId != null ? 'user_id = ?' : null,
        whereArgs: userId != null ? [userId] : null,
        orderBy: 'created_at DESC',
      );
      
      if (results.isEmpty) {
        print('INFO: No saved builds found');
      } else {
        print('INFO: Retrieved ${results.length} saved builds from SQLite');
      }
      
      return results.map((row) => BuildConfiguration.fromDbJson(row)).toList();
    } catch (e) {
      print('ERROR: Failed to fetch saved builds: $e');
      rethrow;
    }
  }

  Future<BuildConfiguration> saveBuild(BuildConfiguration build, {String? userId}) async {
    try {
      if (build.id.isEmpty || build.name.isEmpty) {
        throw Exception('Build ID and name cannot be empty');
      }

      print('DEBUG: Saving build to SQLite - ID: ${build.id}, Name: ${build.name}');
      final db = await database;
      
      final data = {
        ...build.toDbJson(),
        'user_id': userId ?? 'current_user',
      };
      
      print('DEBUG: Build data: CPU=${build.cpu?.name ?? "None"}, GPU=${build.gpu?.name ?? "None"}');
      
      await db.insert(
        _buildsTable,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      print('INFO: Build saved successfully to SQLite');
      return build;
    } catch (e) {
      print('ERROR: Failed to save build: $e');
      rethrow;
    }
  }

  Future<void> deleteBuild(String buildId) async {
    try {
      if (buildId.isEmpty) {
        throw Exception('Build ID cannot be empty');
      }

      print('DEBUG: Deleting build from SQLite - ID: $buildId');
      final db = await database;
      
      final rowsDeleted = await db.delete(
        _buildsTable, 
        where: 'build_id = ?', 
        whereArgs: [buildId],
      );
      
      if (rowsDeleted == 0) {
        print('WARNING: No build found with ID: $buildId');
      } else {
        print('INFO: Build deleted successfully - Rows deleted: $rowsDeleted');
      }
    } catch (e) {
      print('ERROR: Failed to delete build: $e');
      rethrow;
    }
  }

  Future<BuildConfiguration?> getBuild(String buildId) async {
    try {
      if (buildId.isEmpty) {
        throw Exception('Build ID cannot be empty');
      }

      print('DEBUG: Fetching build from SQLite - ID: $buildId');
      final db = await database;
      final result = await db.query(
        _buildsTable,
        where: 'build_id = ?',
        whereArgs: [buildId],
      );
      
      if (result.isEmpty) {
        print('WARNING: Build not found - ID: $buildId');
        return null;
      }
      
      final build = BuildConfiguration.fromDbJson(result.first);
      print('INFO: Build retrieved successfully');
      return build;
    } catch (e) {
      print('ERROR: Failed to fetch build: $e');
      rethrow;
    }
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