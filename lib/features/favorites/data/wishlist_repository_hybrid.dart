// lib/features/favorites/data/wishlist_repository_hybrid.dart

import '../domain/wishlist_model.dart';
import 'wishlist_repository_sqlite.dart';
import 'wishlist_repository_supabase.dart';

/// Hybrid repository that uses both SQLite (local cache) and Supabase (remote backend)
/// Provides offline-first experience with automatic sync when online
class WishlistRepositoryHybrid {
  final WishlistRepositorySQLite _sqlite;
  final WishlistRepositorySupabase _supabase;
  bool _isOnline = true;

  WishlistRepositoryHybrid({
    WishlistRepositorySQLite? sqlite,
    WishlistRepositorySupabase? supabase,
  })  : _sqlite = sqlite ?? WishlistRepositorySQLite(),
        _supabase = supabase ?? WishlistRepositorySupabase();

  /// Get wishlist items with local cache priority
  /// Returns cached items immediately, syncs with backend if online
  Future<List<WishlistItem>> getWishlistItems({String? userId}) async {
    try {
      // Return local cache first (offline-first)
      final cachedItems = await _sqlite.getWishlistItems(userId: userId);
      if (cachedItems.isNotEmpty || !_isOnline) {
        return cachedItems;
      }

      // Fetch from Supabase and cache
      final remoteItems = await _supabase.getWishlistItems();
      
      // Update local cache
      for (final item in remoteItems) {
        await _sqlite.addToWishlist(item, userId: userId);
      }
      
      return remoteItems;
    } catch (e) {
      // Fallback to cache on error
      return await _sqlite.getWishlistItems(userId: userId);
    }
  }

  /// Add item to wishlist (local + remote)
  Future<void> addToWishlist(WishlistItem item, {String? userId}) async {
    // Always save to local cache first
    await _sqlite.addToWishlist(item, userId: userId);

    // Sync to remote if online
    if (_isOnline) {
      try {
        await _supabase.addToWishlist(item);
      } catch (e) {
        // Item queued for sync via SQLite sync queue
        print('Remote add failed, queued for sync: $e');
      }
    }
  }

  /// Remove item from wishlist (local + remote)
  Future<void> removeFromWishlist(String itemId) async {
    // Remove from local
    await _sqlite.removeFromWishlist(itemId);

    // Remove from remote if online
    if (_isOnline) {
      try {
        await _supabase.removeFromWishlist(itemId);
      } catch (e) {
        print('Remote remove failed: $e');
      }
    }
  }

  /// Clear entire wishlist
  Future<void> clearWishlist() async {
    // Clear local
    await _sqlite.clearWishlist();

    // Clear remote if online
    if (_isOnline) {
      try {
        await _supabase.clearWishlist();
      } catch (e) {
        print('Remote clear failed: $e');
      }
    }
  }

  /// Check if item is in wishlist
  Future<bool> isInWishlist(String itemId) async {
    return await _sqlite.isInWishlist(itemId);
  }

  /// Get wishlist item count
  Future<int> getWishlistCount() async {
    return await _sqlite.getWishlistCount();
  }

  /// Set online status (called by connectivity service)
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
}
