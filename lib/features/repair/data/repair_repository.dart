// lib/features/repair/data/repair_repository.dart

import '../domain/repair_model.dart';
import 'package:flutter/material.dart';
class RepairRepository {
  // Available repair services
  static const List<DeviceIssue> availableIssues = [
    DeviceIssue(
      id: 'issue_1',
      name: 'Overheating',
      description: 'Device gets too hot, fan noise, thermal throttling',
      type: RepairType.hardware,
      basePrice: 89.00,
      estimatedTime: Duration(hours: 2),
      icon: Icons.thermostat,
    ),
    DeviceIssue(
      id: 'issue_2',
      name: 'Slow Performance',
      description: 'System running slow, lagging, freezing',
      type: RepairType.software,
      basePrice: 79.00,
      estimatedTime: Duration(hours: 1),
      icon: Icons.speed,
    ),
    DeviceIssue(
      id: 'issue_3',
      name: 'Screen Replacement',
      description: 'Cracked, broken, or malfunctioning display',
      type: RepairType.hardware,
      basePrice: 199.00,
      estimatedTime: Duration(hours: 3),
      icon: Icons.phone_android,
    ),
    DeviceIssue(
      id: 'issue_4',
      name: 'Battery Issues',
      description: 'Battery not charging, draining fast, swollen',
      type: RepairType.hardware,
      basePrice: 129.00,
      estimatedTime: Duration(hours: 2),
      icon: Icons.battery_alert,
    ),
    DeviceIssue(
      id: 'issue_5',
      name: 'Virus/Malware',
      description: 'Pop-ups, slow performance, unusual behavior',
      type: RepairType.software,
      basePrice: 99.00,
      estimatedTime: Duration(hours: 2),
      icon: Icons.security,
    ),
    DeviceIssue(
      id: 'issue_6',
      name: 'Data Recovery',
      description: 'Lost files, corrupted drive, accidental deletion',
      type: RepairType.dataRecovery,
      basePrice: 149.00,
      estimatedTime: Duration(hours: 4),
      icon: Icons.data_usage,
    ),
    DeviceIssue(
      id: 'issue_7',
      name: 'Deep Cleaning',
      description: 'Dust removal, thermal paste replacement',
      type: RepairType.cleaning,
      basePrice: 69.00,
      estimatedTime: Duration(hours: 1),
      icon: Icons.cleaning_services,
    ),
    DeviceIssue(
      id: 'issue_8',
      name: 'Hardware Upgrade',
      description: 'RAM, SSD, or component upgrade',
      type: RepairType.upgrade,
      basePrice: 59.00,
      estimatedTime: Duration(hours: 1),
      icon: Icons.upgrade,
    ),
  ];

  Future<List<RepairRequest>> getRepairHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      RepairRequest(
        id: 'repair_1',
        orderNumber: 'R-2024-001',
        deviceType: DeviceType.laptop,
        deviceModel: 'NovaBook Pro 16',
        issues: ['Overheating', 'Cleaning'],
        description: 'Laptop getting very hot during gaming',
        submittedAt: DateTime(2024, 1, 10),
        status: RepairStatus.completed,
        estimatedPrice: 158.00,
        finalPrice: 158.00,
        scheduledDate: DateTime(2024, 1, 12),
        technicianName: 'John Tech',
      ),
      RepairRequest(
        id: 'repair_2',
        orderNumber: 'R-2024-002',
        deviceType: DeviceType.gamingPc,
        deviceModel: 'Apex-Ultimate Gaming Rig',
        issues: ['Slow Performance'],
        description: 'PC running slow after Windows update',
        submittedAt: DateTime(2024, 1, 20),
        status: RepairStatus.inProgress,
        estimatedPrice: 79.00,
        scheduledDate: DateTime(2024, 1, 22),
        technicianName: 'Sarah Chen',
      ),
    ];
  }

  Future<RepairRequest> submitRepairRequest({
    required DeviceType deviceType,
    required String deviceModel,
    required List<String> issues,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Calculate estimated price
    double estimatedPrice = 0;
    for (final issueId in issues) {
      final issue = availableIssues.firstWhere((i) => i.id == issueId);
      estimatedPrice += issue.basePrice;
    }
    
    // Apply discount for multiple issues
    if (issues.length > 1) {
      estimatedPrice = estimatedPrice * 0.9;
    }
    
    return RepairRequest(
      id: 'repair_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'R-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 4)}',
      deviceType: deviceType,
      deviceModel: deviceModel,
      issues: issues,
      description: description,
      submittedAt: DateTime.now(),
      status: RepairStatus.pending,
      estimatedPrice: estimatedPrice,
    );
  }

  Future<void> cancelRepair(String repairId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}