// lib/features/cart/data/cart_repository_hybrid.dart

import 'package:flutter/foundation.dart';
import '../domain/cart_model.dart';
import 'cart_repository_sqlite.dart';
import 'cart_repository_supabase.dart';

/// Hybrid cart repository using SQLite locally with Supabase sync
/// The cart is primarily local and syncs when online
class CartRepositoryHybrid {
  final CartRepositorySQLite _sqlite;
  final CartRepositorySupabase _supabase;
  final List<CartItem> _webCartItems = [];
  bool _isOnline = true;

  CartRepositoryHybrid({
    CartRepositorySQLite? sqlite,
    CartRepositorySupabase? supabase,
  })  : _sqlite = sqlite ?? CartRepositorySQLite(),
        _supabase = supabase ?? CartRepositorySupabase();

  /// Get all cart items from local storage
  Future<List<CartItem>> getCartItems({String? userId}) async {
    if (kIsWeb) {
      return List.unmodifiable(_webCartItems);
    }
    return await _sqlite.getCartItems(userId: userId);
  }

  /// Add item to cart locally (queues for remote sync if applicable)
  Future<void> addToCart(CartItem item, {String? userId}) async {
    if (kIsWeb) {
      final existingIndex = _webCartItems.indexWhere((existing) {
        return existing.productId == item.productId && existing.buildId == item.buildId;
      });
      if (existingIndex >= 0) {
        final existingItem = _webCartItems[existingIndex];
        _webCartItems[existingIndex] = CartItem(
          cartItemId: existingItem.cartItemId,
          productId: existingItem.productId,
          buildId: existingItem.buildId,
          name: existingItem.name,
          type: existingItem.type,
          variant: existingItem.variant,
          quantity: existingItem.quantity + item.quantity,
          price: item.price,
          imageUrl: existingItem.imageUrl ?? item.imageUrl,
          addedAt: existingItem.addedAt,
        );
      } else {
        _webCartItems.add(item);
      }
      return;
    }

    await _sqlite.addToCart(item, userId: userId);

    if (_isOnline) {
      try {
        await _supabase.addToCart(item);
      } catch (e) {
        debugPrint('Cart sync add failed, keeping local queue: $e');
      }
    }
  }

  /// Update quantity of cart item
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    if (kIsWeb) {
      final index = _webCartItems.indexWhere((item) => item.cartItemId == cartItemId);
      if (index == -1) return;
      if (quantity <= 0) {
        _webCartItems.removeAt(index);
      } else {
        final existing = _webCartItems[index];
        _webCartItems[index] = CartItem(
          cartItemId: existing.cartItemId,
          productId: existing.productId,
          buildId: existing.buildId,
          name: existing.name,
          type: existing.type,
          variant: existing.variant,
          quantity: quantity,
          price: existing.price,
          imageUrl: existing.imageUrl,
          addedAt: existing.addedAt,
        );
      }
      return;
    }

    await _sqlite.updateQuantity(cartItemId, quantity);

    if (_isOnline) {
      try {
        await _supabase.updateQuantity(cartItemId, quantity);
      } catch (e) {
        debugPrint('Cart sync update failed, keeping local update for retry: $e');
      }
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    if (kIsWeb) {
      _webCartItems.removeWhere((item) => item.cartItemId == cartItemId);
      return;
    }
    await _sqlite.removeFromCart(cartItemId);

    if (_isOnline) {
      try {
        await _supabase.removeFromCart(cartItemId);
      } catch (e) {
        debugPrint('Cart sync remove failed, keeping local removal for retry: $e');
      }
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    if (kIsWeb) {
      _webCartItems.clear();
      return;
    }
    await _sqlite.clearCart();

    if (_isOnline) {
      try {
        await _supabase.clearCart();
      } catch (e) {
        debugPrint('Cart sync clear failed, keeping local clear for retry: $e');
      }
    }
  }

  /// Get cart total price
  Future<double> getCartTotal() async {
    if (kIsWeb) {
      return _webCartItems.fold<double>(0.0, (total, item) => total + item.price * item.quantity);
    }
    return await _sqlite.getCartTotal();
  }

  /// Get total item count in cart
  Future<int> getCartItemCount() async {
    if (kIsWeb) {
      return _webCartItems.fold<int>(0, (count, item) => count + item.quantity);
    }
    return await _sqlite.getCartItemCount();
  }

  /// Set online status (called by connectivity service)
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
}
