// lib/features/pc_builder/data/builder_repository_supabase.dart

import '../../../core/supabase/supabase_client.dart';
import '../domain/builder_model.dart';

class BuilderRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  int _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now().millisecondsSinceEpoch;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
      return DateTime.tryParse(value)?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    }
    return DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> _normalizeRow(Map<String, dynamic> row) {
    return {
      'build_id': row['build_id'] ?? row['id'],
      'name': row['name'],
      'created_at': _parseTimestamp(row['created_at']),
      'cpu_id': row['cpu_id'],
      'gpu_id': row['gpu_id'],
      'motherboard_id': row['motherboard_id'],
      'ram_id': row['ram_id'],
      'storage_id': row['storage_id'],
      'cooling_id': row['cooling_id'],
      'psu_id': row['psu_id'],
      'case_id': row['case_id'],
    };
  }

  Future<List<BuildConfiguration>> getSavedBuilds() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('WARNING: No authenticated user - returning empty builds');
        return [];
      }

      print('DEBUG: Fetching saved builds from Supabase for user: ${user.id}');
      final response = await _supabase.client
          .from('build_configurations')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (response is! List) {
        throw Exception('Invalid response format from build_configurations table');
      }

      final builds = (response as List)
          .map((json) => BuildConfiguration.fromDbJson(_normalizeRow(json as Map<String, dynamic>)))
          .toList();
      
      print('INFO: Retrieved ${builds.length} saved builds from Supabase');
      return builds;
    } catch (e) {
      print('ERROR: Failed to fetch saved builds from Supabase: $e');
      rethrow;
    }
  }

  Future<void> saveBuild(BuildConfiguration build, {String? userId}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Validate build data
      if (build.id.isEmpty || build.name.isEmpty) {
        throw Exception('Build ID and name cannot be empty');
      }

      print('DEBUG: Saving build to Supabase - ID: ${build.id}, Name: ${build.name}');
      print('DEBUG: Components - CPU: ${build.cpu?.name ?? "None"}, GPU: ${build.gpu?.name ?? "None"}');

      await _supabase.client.from('build_configurations').insert({
        'build_id': build.id,
        'user_id': userId ?? user.id,
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
      });
      
      print('INFO: Build saved to Supabase successfully');
    } catch (e) {
      print('ERROR: Failed to save build to Supabase: $e');
      rethrow;
    }
  }

  Future<void> deleteBuild(String buildId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      if (buildId.isEmpty) {
        throw Exception('Build ID cannot be empty');
      }

      print('DEBUG: Deleting build from Supabase - ID: $buildId');

      await _supabase.client
          .from('build_configurations')
          .delete()
          .eq('user_id', user.id)
          .eq('build_id', buildId);
      
      print('INFO: Build deleted from Supabase successfully');
    } catch (e) {
      print('ERROR: Failed to delete build from Supabase: $e');
      rethrow;
    }
  }
}
