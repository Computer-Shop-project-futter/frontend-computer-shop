// lib/features/repair/data/repair_repository_supabase.dart

import '../../../core/supabase/supabase_client.dart';
import '../domain/repair_model.dart';

class RepairRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  Future<List<RepairRequest>> getRepairRequests() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print('WARNING: No authenticated user found');
        return [];
      }

      print('DEBUG: Fetching repair requests for user: ${user.id}');
      final response = await _supabase.client
          .from('repair_requests')
          .select()
          .eq('user_id', user.id)
          .order('submitted_at', ascending: false);

      if (response is! List) {
        throw Exception('Invalid response format from repair_requests table');
      }
      
      final repairs = (response as List)
          .map((json) => RepairRequest.fromDbJson(json as Map<String, dynamic>))
          .toList();
      
      print('INFO: Retrieved ${repairs.length} repair requests from database');
      return repairs;
    } catch (e) {
      print('ERROR: Failed to fetch repair requests: $e');
      rethrow;
    }
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
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Validate inputs
      if (repairId.isEmpty || orderNumber.isEmpty || deviceModel.isEmpty) {
        throw Exception('Required fields cannot be empty');
      }
      if (estimatedPrice < 0) {
        throw Exception('Estimated price cannot be negative');
      }

      print('DEBUG: Submitting repair to database - ID: $repairId, Order: $orderNumber');
      print('DEBUG: Device: $deviceModel, Type: ${deviceType.toString().split('.').last}');
      
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
      
      print('INFO: Repair request saved to database successfully');
    } catch (e) {
      print('ERROR: Failed to submit repair request to database: $e');
      rethrow;
    }
  }

  Future<void> cancelRepair(String repairId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      if (repairId.isEmpty) {
        throw Exception('Repair ID cannot be empty');
      }

      print('DEBUG: Cancelling repair in database - ID: $repairId');
      
      final response = await _supabase.client
          .from('repair_requests')
          .update({'status': 'cancelled'})
          .eq('user_id', user.id)
          .eq('repair_id', repairId);

      print('INFO: Repair cancelled successfully in database');
    } catch (e) {
      print('ERROR: Failed to cancel repair: $e');
      rethrow;
    }
  }
}
