// lib/features/cart/data/cart_repository_hybrid.dart

import '../domain/cart_model.dart';
import 'cart_repository_sqlite.dart';

/// Hybrid cart repository using SQLite locally with Supabase sync
/// The cart is primarily local and syncs when online
class CartRepositoryHybrid {
  final CartRepositorySQLite _sqlite;
  bool _isOnline = true;

  CartRepositoryHybrid({
    CartRepositorySQLite? sqlite,
  }) : _sqlite = sqlite ?? CartRepositorySQLite();

  /// Get all cart items from local storage
  Future<List<CartItem>> getCartItems({String? userId}) async {
    return await _sqlite.getCartItems(userId: userId);
  }

  /// Add item to cart locally (queues for remote sync if applicable)
  Future<void> addToCart(CartItem item, {String? userId}) async {
    await _sqlite.addToCart(item, userId: userId);
    // SQLite automatically queues for sync via addToSyncQueue
  }

  /// Update quantity of cart item
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await _sqlite.updateQuantity(cartItemId, quantity);
  }

  /// Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    await _sqlite.removeFromCart(cartItemId);
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    await _sqlite.clearCart();
  }

  /// Get cart total price
  Future<double> getCartTotal() async {
    return await _sqlite.getCartTotal();
  }

  /// Get total item count in cart
  Future<int> getCartItemCount() async {
    return await _sqlite.getCartItemCount();
  }

  /// Set online status
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
}
