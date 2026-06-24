// lib/features/cart/data/cart_repository_supabase.dart

import '../../../core/supabase/supabase_client.dart';
import '../domain/cart_model.dart';

class CartRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  int _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now().millisecondsSinceEpoch;
    if (value is int) return value;
    if (value is String) {
      final asInt = int.tryParse(value);
      if (asInt != null) return asInt;
      return DateTime.tryParse(value)?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    }
    return DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> _normalizeRow(Map<String, dynamic> row) {
    return {
      'cart_item_id': row['cart_item_id'] ?? row['id'],
      'product_id': row['product_id'],
      'build_id': row['build_id'],
      'name': row['name'],
      'type': row['type'],
      'variant': row['variant'],
      'quantity': row['quantity'],
      'price': row['price'],
      'image_url': row['image_url'],
      'added_at': _parseTimestamp(row['added_at']),
    };
  }

  Future<List<CartItem>> getCartItems() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase.client
        .from('cart_items')
        .select()
        .eq('user_id', user.id)
        .order('added_at', ascending: false);

    return (response as List)
        .map((json) => CartItem.fromDbJson(_normalizeRow(json as Map<String, dynamic>)))
        .toList();
  }

  Future<void> addToCart(CartItem item) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _supabase.client.from('cart_items').insert({
      'cart_item_id': item.cartItemId,
      'user_id': user.id,
      'product_id': item.productId,
      'build_id': item.buildId,
      'name': item.name,
      'type': item.type,
      'variant': item.variant,
      'quantity': item.quantity,
      'price': item.price,
      'image_url': item.imageUrl,
      'added_at': item.addedAt,
    });
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.client
        .from('cart_items')
        .update({'quantity': quantity})
        .eq('user_id', user.id)
        .eq('cart_item_id', cartItemId);
  }

  Future<void> removeFromCart(String cartItemId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.client
        .from('cart_items')
        .delete()
        .eq('user_id', user.id)
        .eq('cart_item_id', cartItemId);
  }

  Future<void> clearCart() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.client
        .from('cart_items')
        .delete()
        .eq('user_id', user.id);
  }
}
