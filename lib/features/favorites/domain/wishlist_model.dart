// lib/features/wishlist/domain/wishlist_model.dart

import 'dart:convert';

enum WishlistItemType {
  product,
  savedBuild,
}

class WishlistItem {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final WishlistItemType type;
  final DateTime addedAt;
  final Map<String, dynamic>? metadata; // For build specs, etc.

  const WishlistItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.type,
    required this.addedAt,
    this.metadata,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl']?.toString(),
      type: json['type'] == 'build' 
          ? WishlistItemType.savedBuild 
          : WishlistItemType.product,
      addedAt: DateTime.parse(json['addedAt']?.toString() ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'type': type == WishlistItemType.savedBuild ? 'build' : 'product',
      'addedAt': addedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  Map<String, dynamic> toDbJson() {
    return {
      'item_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'type': type == WishlistItemType.savedBuild ? 'build' : 'product',
      'added_at': addedAt.millisecondsSinceEpoch,
      'metadata': metadata != null ? jsonEncode(metadata!) : null,
    };
  }

  factory WishlistItem.fromDbJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['item_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image_url']?.toString(),
      type: json['type'] == 'build' 
          ? WishlistItemType.savedBuild 
          : WishlistItemType.product,
      addedAt: DateTime.fromMillisecondsSinceEpoch(json['added_at'] as int? ?? 0),
      metadata: json['metadata'] != null 
          ? jsonDecode(json['metadata'] as String) as Map<String, dynamic>
          : null,
    );
  }
}

class WishlistState {
  final List<WishlistItem> items;
  final Set<String> selectedCategoryFilters;
  final String? searchQuery;
  final bool isLoading;

  const WishlistState({
    required this.items,
    this.selectedCategoryFilters = const {},
    this.searchQuery,
    this.isLoading = false,
  });

  // Get filtered items based on search and categories
  List<WishlistItem> get filteredItems {
    var filtered = items;

    // Apply search filter
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filtered = filtered.where((item) =>
        item.name.toLowerCase().contains(searchQuery!.toLowerCase()) ||
        (item.description?.toLowerCase().contains(searchQuery!.toLowerCase()) ?? false)
      ).toList();
    }

    // Apply category filters (products vs builds)
    if (selectedCategoryFilters.contains('products')) {
      filtered = filtered.where((item) => item.type == WishlistItemType.product).toList();
    }
    if (selectedCategoryFilters.contains('builds')) {
      filtered = filtered.where((item) => item.type == WishlistItemType.savedBuild).toList();
    }

    return filtered;
  }

  int get productCount => items.where((i) => i.type == WishlistItemType.product).length;
  int get buildCount => items.where((i) => i.type == WishlistItemType.savedBuild).length;

  WishlistState copyWith({
    List<WishlistItem>? items,
    Set<String>? selectedCategoryFilters,
    String? searchQuery,
    bool? isLoading,
  }) {
    return WishlistState(
      items: items ?? this.items,
      selectedCategoryFilters: selectedCategoryFilters ?? this.selectedCategoryFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}