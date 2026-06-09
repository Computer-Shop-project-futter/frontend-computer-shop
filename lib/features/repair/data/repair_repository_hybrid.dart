// lib/features/repair/data/repair_repository_hybrid.dart

import '../domain/repair_model.dart';
import 'repair_repository.dart';
import '../../../core/repositories/base_repository.dart';

/// Hybrid repair repository using local storage with Supabase sync
class RepairRepositoryHybrid extends BaseRepository {
  final RepairRepository _local;
  bool _isOnline = true;

  RepairRepositoryHybrid({
    RepairRepository? local,
  }) : _local = local ?? RepairRepository();

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

    // Queue for sync when online
    if (_isOnline) {
      await addToSyncQueue(
        operation: 'INSERT',
        tableName: 'repair_requests',
        data: {
          'repair_id': repair.id,
          'order_number': repair.orderNumber,
          'device_type': deviceType.toString(),
          'device_model': repair.deviceModel,
          'issues': issues.join(','),
          'description': repair.description,
          'submitted_at': repair.submittedAt.millisecondsSinceEpoch,
          'estimated_price': repair.estimatedPrice,
        },
      );
    }

    return repair;
  }

  /// Cancel repair request
  Future<void> cancelRepair(String repairId) async {
    await _local.cancelRepair(repairId);

    // Queue sync
    if (_isOnline) {
      await addToSyncQueue(
        operation: 'UPDATE',
        tableName: 'repair_requests',
        data: {'repair_id': repairId, 'status': 'cancelled'},
      );
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
