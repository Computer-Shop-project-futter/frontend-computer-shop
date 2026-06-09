// lib/features/account/presentation/providers/account_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/account_repository.dart';
import '../../domain/account_model.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository();
});

final accountProvider = StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  return AccountNotifier(ref.read(accountRepositoryProvider));
});

class AccountNotifier extends StateNotifier<AccountState> {
  final AccountRepository _repository;

  AccountNotifier(this._repository) : super(const AccountState()) {
    loadAccountData();
  }

  Future<void> loadAccountData() async {
    state = state.copyWith(isLoading: true);
    
    final results = await Future.wait([
      _repository.getUserProfile(),
      _repository.getRecentOrders(),
      _repository.getAddresses(),
    ]);

    state = state.copyWith(
      user: results[0] as UserProfile,
      recentOrders: results[1] as List<Order>,
      addresses: results[2] as List<Address>,
      isLoading: false,
    );
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true);
    
    final updatedUser = await _repository.updateUserProfile(
      fullName: fullName,
      email: email,
      phone: phone,
    );
    
    state = state.copyWith(
      user: updatedUser,
      isLoading: false,
    );
  }

  void setSelectedTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    // Navigation handled in UI
  }
}