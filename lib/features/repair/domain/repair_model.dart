// lib/features/repair/domain/repair_model.dart

import 'package:flutter/material.dart';

enum DeviceType {
  laptop,
  desktop,
  gamingPc,
  workstation,
  peripheral,
}

enum RepairType {
  hardware,
  software,
  diagnostic,
  cleaning,
  upgrade,
  dataRecovery,
}

enum RepairStatus {
  pending,
  diagnosed,
  inProgress,
  awaitingParts,
  completed,
  cancelled,
}

class DeviceIssue {
  final String id;
  final String name;
  final String description;
  final RepairType type;
  final double basePrice;
  final Duration estimatedTime;
  final IconData icon;

  const DeviceIssue({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.basePrice,
    required this.estimatedTime,
    required this.icon,
  });
}

class RepairRequest {
  final String id;
  final String orderNumber;
  final DeviceType deviceType;
  final String deviceModel;
  final List<String> issues;
  final String description;
  final DateTime submittedAt;
  final RepairStatus status;
  final double estimatedPrice;
  final double? finalPrice;
  final DateTime? scheduledDate;
  final String? technicianName;

  const RepairRequest({
    required this.id,
    required this.orderNumber,
    required this.deviceType,
    required this.deviceModel,
    required this.issues,
    required this.description,
    required this.submittedAt,
    required this.status,
    required this.estimatedPrice,
    this.finalPrice,
    this.scheduledDate,
    this.technicianName,
  });

  String get statusText {
    switch (status) {
      case RepairStatus.pending:
        return 'Pending Review';
      case RepairStatus.diagnosed:
        return 'Diagnosed';
      case RepairStatus.inProgress:
        return 'In Progress';
      case RepairStatus.awaitingParts:
        return 'Awaiting Parts';
      case RepairStatus.completed:
        return 'Completed';
      case RepairStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case RepairStatus.pending:
        return const Color(0xFFF59E0B);
      case RepairStatus.diagnosed:
        return const Color(0xFF2A66FF);
      case RepairStatus.inProgress:
        return const Color(0xFF8B5CF6);
      case RepairStatus.awaitingParts:
        return const Color(0xFFF59E0B);
      case RepairStatus.completed:
        return const Color(0xFF10B981);
      case RepairStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

class RepairState {
  final List<RepairRequest> repairHistory;
  final RepairRequest? currentRepair;
  final bool isLoading;
  final String? error;
  final DeviceType? selectedDeviceType;
  final List<String> selectedIssues;
  final String deviceModel;
  final String description;
  final int step;

  const RepairState({
    this.repairHistory = const [],
    this.currentRepair,
    this.isLoading = false,
    this.error,
    this.selectedDeviceType,
    this.selectedIssues = const [],
    this.deviceModel = '',
    this.description = '',
    this.step = 0,
  });

  RepairState copyWith({
    List<RepairRequest>? repairHistory,
    RepairRequest? currentRepair,
    bool? isLoading,
    String? error,
    DeviceType? selectedDeviceType,
    List<String>? selectedIssues,
    String? deviceModel,
    String? description,
    int? step,
  }) {
    return RepairState(
      repairHistory: repairHistory ?? this.repairHistory,
      currentRepair: currentRepair ?? this.currentRepair,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedDeviceType: selectedDeviceType ?? this.selectedDeviceType,
      selectedIssues: selectedIssues ?? this.selectedIssues,
      deviceModel: deviceModel ?? this.deviceModel,
      description: description ?? this.description,
      step: step ?? this.step,
    );
  }
}