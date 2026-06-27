import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Reusable product card widget
/// Used in Home, Product Listing, Wishlist, Compare pages
class ProductCard extends StatelessWidget {
  final String productName;
  final String? brandName;
  final double basePrice;
  final double? dealPrice;
  final String? imageUrl;
  final bool isFeatured;
  final bool isDeal;
  final double? rating;
  final int? reviewCount;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onAddToWishlist;
  final bool isInWishlist;

  const ProductCard({
    super.key,
    required this.productName,
    this.brandName,
    required this.basePrice,
    this.dealPrice,
    this.imageUrl,
    this.isFeatured = false,
    this.isDeal = false,
    this.rating,
    this.reviewCount,
    this.onTap,
    this.onAddToCart,
    this.onAddToWishlist,
    this.isInWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: AppColors.kSurface,
                  child: imageUrl != null
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                ),
                // Badges
                if (isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.kDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'FEATURED',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.kBackground,
                        ),
                      ),
                    ),
                  ),
                if (isDeal)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.kDealBadge,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SALE',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.kBackground,
                        ),
                      ),
                    ),
                  ),
                // Wishlist button
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onAddToWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.kBackground,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.kBorder),
                      ),
                      child: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? AppColors.kDealBadge : AppColors.kSecondaryText,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (brandName != null)
                      Text(
                        brandName!,
                        style: AppTextStyles.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Text(
                      productName,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Rating
                    if (rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.kDark),
                          const SizedBox(width: 4),
                          Text(
                            '$rating',
                            style: AppTextStyles.labelSmall,
                          ),
                          if (reviewCount != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount)',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    const SizedBox(height: 8),
                    // Price
                    Row(
                      children: [
                        if (dealPrice != null) ...[
                          Text(
                            '\$${basePrice.toStringAsFixed(0)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '\$${(dealPrice ?? basePrice).toStringAsFixed(0)}',
                          style: AppTextStyles.priceStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Add to cart button
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
