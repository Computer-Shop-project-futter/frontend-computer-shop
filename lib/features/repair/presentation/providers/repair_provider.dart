// lib/features/repair/presentation/providers/repair_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repair_repository_hybrid.dart';
import '../../domain/repair_model.dart';

final repairRepositoryProvider = Provider<RepairRepositoryHybrid>((ref) {
  return RepairRepositoryHybrid();
});

final repairProvider = StateNotifierProvider<RepairNotifier, RepairState>((ref) {
  return RepairNotifier(ref.read(repairRepositoryProvider));
});

class RepairNotifier extends StateNotifier<RepairState> {
  final RepairRepositoryHybrid _repository;

  RepairNotifier(this._repository) : super(const RepairState()) {
    loadRepairHistory();
  }

  Future<void> loadRepairHistory() async {
    state = state.copyWith(isLoading: true);
    final history = await _repository.getRepairHistory();
    state = state.copyWith(repairHistory: history, isLoading: false);
  }

  void setDeviceType(DeviceType type) {
    state = state.copyWith(selectedDeviceType: type);
  }

  void toggleIssue(String issueId) {
    final newIssues = List<String>.from(state.selectedIssues);
    if (newIssues.contains(issueId)) {
      newIssues.remove(issueId);
    } else {
      newIssues.add(issueId);
    }
    state = state.copyWith(selectedIssues: newIssues);
  }

  void setDeviceModel(String model) {
    state = state.copyWith(deviceModel: model);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void nextStep() {
    state = state.copyWith(step: state.step + 1);
  }

  void previousStep() {
    state = state.copyWith(step: state.step - 1);
  }

  void resetForm() {
    state = state.copyWith(
      selectedDeviceType: null,
      selectedIssues: [],
      deviceModel: '',
      description: '',
      step: 0,
    );
  }

  Future<void> submitRepair() async {
    if (state.selectedDeviceType == null ||
        state.deviceModel.isEmpty ||
        state.selectedIssues.isEmpty) {
      state = state.copyWith(error: 'Please fill in all required fields');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    final repair = await _repository.submitRepairRequest(
      deviceType: state.selectedDeviceType!,
      deviceModel: state.deviceModel,
      issues: state.selectedIssues,
      description: state.description,
    );
    
    final updatedHistory = [repair, ...state.repairHistory];
    state = state.copyWith(
      repairHistory: updatedHistory,
      currentRepair: repair,
      isLoading: false,
    );
    
    resetForm();
  }

  Future<void> cancelRepair(String repairId) async {
    await _repository.cancelRepair(repairId);
    await loadRepairHistory();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}