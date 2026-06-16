// lib/features/repair/data/repair_repository_supabase.dart

import '../../../core/supabase/supabase_client.dart';
import '../domain/repair_model.dart';

class RepairRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  Future<List<RepairRequest>> getRepairRequests() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase.client
        .from('repair_requests')
        .select()
        .eq('user_id', user.id)
        .order('submitted_at', ascending: false);

    return (response as List)
        .map((json) => RepairRequest.fromDbJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> submitRepairRequest({
    required String repairId,
    required String orderNumber,
    required DeviceType deviceType,
    required String deviceModel,
    required List<String> issues,
    required String description,
    required DateTime submittedAt,
    required double estimatedPrice,
    required RepairStatus status,
    double? finalPrice,
    DateTime? scheduledDate,
    String? technicianName,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _supabase.client.from('repair_requests').insert({
      'repair_id': repairId,
      'user_id': user.id,
      'order_number': orderNumber,
      'device_type': deviceType.toString().split('.').last,
      'device_model': deviceModel,
      'issues': issues,
      'description': description,
      'submitted_at': submittedAt.millisecondsSinceEpoch,
      'status': status.toString().split('.').last,
      'estimated_price': estimatedPrice,
      'final_price': finalPrice,
      'scheduled_date': scheduledDate?.millisecondsSinceEpoch,
      'technician_name': technicianName,
    });
  }

  Future<void> cancelRepair(String repairId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.client
        .from('repair_requests')
        .update({'status': 'cancelled'})
        .eq('user_id', user.id)
        .eq('repair_id', repairId);
  }
}
