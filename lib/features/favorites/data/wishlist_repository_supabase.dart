// lib/features/wishlist/data/wishlist_repository_supabase.dart

import '../../../core/supabase/supabase_client.dart';
import '../domain/wishlist_model.dart';

class WishlistRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  Future<List<WishlistItem>> getWishlistItems() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];
    
    final response = await _supabase.client
        .from('wishlist')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => WishlistItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> addToWishlist(WishlistItem item) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    
    await _supabase.client.from('wishlist').insert({
      'user_id': user.id,
      'product_id': item.type == WishlistItemType.product ? item.id : null,
      'build_id': item.type == WishlistItemType.savedBuild ? item.id : null,
      'name': item.name,
      'description': item.description,
      'price': item.price,
      'image_url': item.imageUrl,
      'type': item.type == WishlistItemType.product ? 'product' : 'build',
      'metadata': item.metadata,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFromWishlist(String itemId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    
    await _supabase.client
        .from('wishlist')
        .delete();
  }

  Future<void> clearWishlist() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    
    await _supabase.client
        .from('wishlist')
        .delete();
  }
}