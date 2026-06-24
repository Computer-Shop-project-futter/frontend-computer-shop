// lib/features/repair/data/repair_repository_hybrid.dart

import 'package:flutter/foundation.dart';
import '../domain/repair_model.dart';
import 'repair_repository.dart';
import 'repair_repository_supabase.dart';
import '../../../core/repositories/base_repository.dart';

/// Hybrid repair repository using local storage with Supabase sync
class RepairRepositoryHybrid extends BaseRepository {
  final RepairRepository _local;
  final RepairRepositorySupabase _supabase;
  bool _isOnline = true;

  RepairRepositoryHybrid({
    RepairRepository? local,
    RepairRepositorySupabase? supabase,
  }) : _local = local ?? RepairRepository(),
        _supabase = supabase ?? RepairRepositorySupabase();

  /// Get repair history from local storage
  Future<List<RepairRequest>> getRepairHistory() async {
    try {
      print('DEBUG: Fetching repair history from local storage');
      final repairs = await _local.getRepairHistory();
      print('INFO: Retrieved ${repairs.length} repairs from local storage');
      return repairs;
    } catch (e) {
      print('ERROR: Failed to fetch repair history: $e');
      rethrow;
    }
  }

  /// Submit repair request locally (queues for remote sync)
  Future<RepairRequest> submitRepairRequest({
    required DeviceType deviceType,
    required String deviceModel,
    required List<String> issues,
    required String description,
  }) async {
    try {
      print('DEBUG: Submitting repair request (hybrid mode, online: $_isOnline)');
      
      // Create repair locally
      final repair = await _local.submitRepairRequest(
        deviceType: deviceType,
        deviceModel: deviceModel,
        issues: issues,
        description: description,
      );

      print('INFO: Repair created locally - ID: ${repair.id}');

      await addToSyncQueue(
        operation: 'INSERT',
        tableName: 'repair_requests',
        data: {
          'repair_id': repair.id,
          'order_number': repair.orderNumber,
          'device_type': deviceType.toString().split('.').last,
          'device_model': repair.deviceModel,
          'issues': issues,
          'description': repair.description,
          'submitted_at': repair.submittedAt.millisecondsSinceEpoch,
          'status': repair.status.toString().split('.').last,
          'estimated_price': repair.estimatedPrice,
          'final_price': repair.finalPrice,
          'scheduled_date': repair.scheduledDate?.millisecondsSinceEpoch,
          'technician_name': repair.technicianName,
        },
      );
      
      print('DEBUG: Added to sync queue for remote sync');

      if (_isOnline) {
        try {
          print('DEBUG: Attempting online sync to Supabase');
          await _supabase.submitRepairRequest(
            repairId: repair.id,
            orderNumber: repair.orderNumber,
            deviceType: deviceType,
            deviceModel: repair.deviceModel,
            issues: repair.issues,
            description: repair.description,
            submittedAt: repair.submittedAt,
            estimatedPrice: repair.estimatedPrice,
            status: repair.status,
            finalPrice: repair.finalPrice,
            scheduledDate: repair.scheduledDate,
            technicianName: repair.technicianName,
          );
          print('INFO: Repair synced to Supabase successfully');
        } catch (e) {
          print('WARNING: Online sync failed, will retry later: $e');
        }
      } else {
        print('INFO: Offline mode - repair queued for sync when online');
      }

      return repair;
    } catch (e) {
      print('ERROR: Failed to submit repair request: $e');
      rethrow;
    }
  }

  /// Cancel repair request
  Future<void> cancelRepair(String repairId) async {
    try {
      print('DEBUG: Cancelling repair - ID: $repairId (online: $_isOnline)');
      
      await _local.cancelRepair(repairId);
      print('INFO: Repair cancelled locally');

      await addToSyncQueue(
        operation: 'UPDATE',
        tableName: 'repair_requests',
        data: {'repair_id': repairId, 'status': 'cancelled'},
      );

      if (_isOnline) {
        try {
          print('DEBUG: Attempting online sync for cancellation');
          await _supabase.cancelRepair(repairId);
          print('INFO: Cancellation synced to Supabase successfully');
        } catch (e) {
          print('WARNING: Online sync failed for cancellation, will retry later: $e');
        }
      } else {
        print('INFO: Offline mode - cancellation queued for sync when online');
      }
    } catch (e) {
      print('ERROR: Failed to cancel repair: $e');
      rethrow;
    }
  }

  /// Get available repair issues
  List<DeviceIssue> getAvailableIssues() {
    return RepairRepository.availableIssues;
  }

  /// Set online status
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
}
