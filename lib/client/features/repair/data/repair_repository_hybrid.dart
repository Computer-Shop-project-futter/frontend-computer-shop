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
    return await _local.getRepairHistory();
  }

  /// Submit repair request locally (queues for remote sync)
  Future<RepairRequest> submitRepairRequest({
    required DeviceType deviceType,
    required String deviceModel,
    required List<String> issues,
    required String description,
  }) async {
    // Create repair locally
    final repair = await _local.submitRepairRequest(
      deviceType: deviceType,
      deviceModel: deviceModel,
      issues: issues,
      description: description,
    );

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

    if (_isOnline) {
      try {
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
      } catch (e) {
        debugPrint('Repair sync insert failed, queued for later: $e');
      }
    }

    return repair;
  }

  /// Cancel repair request
  Future<void> cancelRepair(String repairId) async {
    await _local.cancelRepair(repairId);

    await addToSyncQueue(
      operation: 'UPDATE',
      tableName: 'repair_requests',
      data: {'repair_id': repairId, 'status': 'cancelled'},
    );

    if (_isOnline) {
      try {
        await _supabase.cancelRepair(repairId);
      } catch (e) {
        debugPrint('Repair sync cancel failed, queued for later: $e');
      }
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
