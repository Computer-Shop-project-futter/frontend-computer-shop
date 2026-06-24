// lib/features/wishlist/presentation/providers/wishlist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/wishlist_repository_hybrid.dart';
import '../../domain/wishlist_model.dart';

final wishlistRepositoryProvider = Provider<WishlistRepositoryHybrid>((ref) {
  return WishlistRepositoryHybrid();
});

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>(
  (ref) => WishlistNotifier(ref.read(wishlistRepositoryProvider)),
);

class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistRepositoryHybrid _repository;

  WishlistNotifier(this._repository) : super(const WishlistState(items: [], isLoading: true)) {
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    state = state.copyWith(isLoading: true);
    final items = await _repository.getWishlistItems();
    state = state.copyWith(items: items, isLoading: false);
  }

  void toggleCategoryFilter(String category) {
    final newFilters = Set<String>.from(state.selectedCategoryFilters);
    if (newFilters.contains(category)) {
      newFilters.remove(category);
    } else {
      newFilters.add(category);
    }
    state = state.copyWith(selectedCategoryFilters: newFilters);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = state.copyWith(selectedCategoryFilters: {}, searchQuery: null);
  }

  Future<void> removeItem(String itemId) async {
    await _repository.removeFromWishlist(itemId);
    final updatedItems = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
  }

  Future<void> addToCart(WishlistItem item) async {
    // In real app: add to cart repository
    // For now, just simulate success
    await Future.delayed(const Duration(milliseconds: 300));
  }
  // Add to WishlistNotifier class
Future<void> clearAll() async {
  await _repository.clearWishlist();
  state = state.copyWith(items: []);
}
}