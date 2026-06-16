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
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase.client
        .from('build_configurations')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => BuildConfiguration.fromDbJson(_normalizeRow(json as Map<String, dynamic>)))
        .toList();
  }

  Future<void> saveBuild(BuildConfiguration build, {String? userId}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

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
  }

  Future<void> deleteBuild(String buildId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.client
        .from('build_configurations')
        .delete()
        .eq('user_id', user.id)
        .eq('build_id', buildId);
  }
}
