import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:computer_shop/client/features/chat/data/staff/geolocation_service_stub.dart';
import 'package:computer_shop/client/features/chat/data/staff/staff_repository.dart';
import 'package:computer_shop/client/features/chat/domain/staff/staff_model.dart';

/// Staff list state
class StaffListState {
  final List<StaffModel> staffList;
  final bool isLoading;
  final String? error;
  final UserPosition? userPosition;

  const StaffListState({
    this.staffList = const [],
    this.isLoading = false,
    this.error,
    this.userPosition,
  });

  StaffListState copyWith({
    List<StaffModel>? staffList,
    bool? isLoading,
    String? error,
    UserPosition? userPosition,
  }) {
    return StaffListState(
      staffList: staffList ?? this.staffList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userPosition: userPosition ?? this.userPosition,
    );
  }
}

/// Provider for staff list
final staffListProvider =
    StateNotifierProvider<StaffListNotifier, StaffListState>((ref) {
  return StaffListNotifier();
});

class StaffListNotifier extends StateNotifier<StaffListState> {
  final StaffRepository _staffRepo = StaffRepository();
  final GeolocationService _geoService = GeolocationService();

  StaffListNotifier() : super(const StaffListState());

  /// Load all available staff
  Future<void> loadStaff() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Try to get user's location first
      final position = await _geoService.getCurrentPosition();
      List<StaffModel> staffList;

      if (position != null) {
        // Get nearby staff sorted by distance
        staffList = await _staffRepo.getNearbyStaff(
          userLat: position.latitude,
          userLng: position.longitude,
        );
        state = state.copyWith(userPosition: position);
      } else {
        staffList = await _staffRepo.getAvailableStaff();
      }

      state = state.copyWith(
        staffList: staffList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load staff: ${e.toString()}',
      );
    }
  }

  /// Refresh the staff list
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await loadStaff();
  }
}