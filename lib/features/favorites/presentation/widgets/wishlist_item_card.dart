// lib/features/wishlist/presentation/widgets/wishlist_item_card.dart

import 'package:flutter/material.dart';
import '../../domain/wishlist_model.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onAddToCart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to product/build detail
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Product/Build Image
                _ItemImage(
                  imageUrl: item.imageUrl,
                  type: item.type,
                ),
                const SizedBox(width: 14),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type Badge
                      _TypeBadge(type: item.type),
                      const SizedBox(height: 6),

                      // Name
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10213B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Description
                      if (item.description != null)
                        Text(
                          item.description!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7891),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),

                      // Price
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2A66FF),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Column(
                  children: [
                    // Add to Cart Button
                    GestureDetector(
                      onTap: onAddToCart,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A66FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Remove Button
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFFEF4444),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final String? imageUrl;
  final WishlistItemType type;

  const _ItemImage({required this.imageUrl, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A3470), Color(0xFF0B1530)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFEAF1FF),
      child: Icon(
        type == WishlistItemType.product 
            ? Icons.memory_rounded 
            : Icons.keyboard_rounded,
        size: 32,
        color: const Color(0xFF2A66FF).withOpacity(0.5),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final WishlistItemType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: type == WishlistItemType.product 
            ? const Color(0xFFEAF1FF) 
            : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type == WishlistItemType.product 
                ? Icons.inventory_2_outlined 
                : Icons.build_outlined,
            size: 10,
            color: type == WishlistItemType.product 
                ? const Color(0xFF2A66FF) 
                : const Color(0xFFD97706),
          ),
          const SizedBox(width: 4),
          Text(
            type == WishlistItemType.product ? 'PRODUCT' : 'SAVED BUILD',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: type == WishlistItemType.product 
                  ? const Color(0xFF2A66FF) 
                  : const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }
}