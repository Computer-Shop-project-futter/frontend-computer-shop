// lib/features/wishlist/data/wishlist_repository.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../domain/wishlist_model.dart';

class WishlistRepository {
  static const String _storageKey = 'wishlist_items';

  Future<List<WishlistItem>> getWishlistItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data based on the screenshot
    return [
      WishlistItem(
        id: 'prod_1',
        name: 'NexCore Pro X1 Processor',
        description: '12-Core, 24-Thread, 5.2GHz Max Boost',
        price: 499.00,
        imageUrl: 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=200',
        type: WishlistItemType.product,
        addedAt: DateTime.now().subtract(const Duration(days: 2)),
        metadata: {'category': 'processors', 'sku': 'NCP-X1-12C'},
      ),
      WishlistItem(
        id: 'prod_2',
        name: 'NexCore Pro X3 Processor',
        description: '16-Core, 32-Thread, 5.5GHz Max Boost',
        price: 799.00,
        imageUrl: 'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=200',
        type: WishlistItemType.product,
        addedAt: DateTime.now().subtract(const Duration(days: 5)),
        metadata: {'category': 'processors', 'sku': 'NCP-X3-16C'},
      ),
      WishlistItem(
        id: 'build_1',
        name: 'Titan-Key Mechanica Deck',
        description: 'Mechanical Keyboard Build | Hot-swappable | RGB',
        price: 220.00,
        imageUrl: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=200',
        type: WishlistItemType.savedBuild,
        addedAt: DateTime.now().subtract(const Duration(days: 1)),
        metadata: {
          'switches': 'Gateron Yellow',
          'keycaps': 'SA Profile',
          'case': 'Aluminum 60%',
        },
      ),
      WishlistItem(
        id: 'build_2',
        name: 'Silent-Click Pro Build',
        description: 'Silent tactile switches, foam dampened',
        price: 185.00,
        imageUrl: 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=200',
        type: WishlistItemType.savedBuild,
        addedAt: DateTime.now().subtract(const Duration(days: 3)),
        metadata: {
          'switches': 'Boba U4 Silent',
          'keycaps': 'MT3 Profile',
          'case': 'Plastic 65%',
        },
      ),
      WishlistItem(
        id: 'prod_3',
        name: 'NexCore Liquid Cooling Kit',
        description: '360mm AIO Liquid Cooler',
        price: 159.00,
        imageUrl: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=200',
        type: WishlistItemType.product,
        addedAt: DateTime.now().subtract(const Duration(days: 7)),
        metadata: {'category': 'cooling'},
      ),
      WishlistItem(
        id: 'prod_4',
        name: 'NexCore RGB RAM 32GB',
        description: 'DDR5 6000MHz RGB Memory Kit',
        price: 129.00,
        imageUrl: 'https://images.unsplash.com/photo-1562976545-7c4a9c7c7c7c?w=200',
        type: WishlistItemType.product,
        addedAt: DateTime.now().subtract(const Duration(days: 10)),
        metadata: {'category': 'memory'},
      ),
    ];
  }

  Future<void> addToWishlist(WishlistItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app: save to backend or local storage
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    existing.add(jsonEncode(item.toJson()));
    await prefs.setStringList(_storageKey, existing);
  }

  Future<void> removeFromWishlist(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    final updated = existing.where((item) {
      final decoded = jsonDecode(item) as Map<String, dynamic>;
      return decoded['id'] != itemId;
    }).toList();
    await prefs.setStringList(_storageKey, updated);
  }

  Future<void> clearWishlist() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}