import 'package:flutter/material.dart';
import 'package:computer_shop/client/features/products/domain/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool isSelectedForCompare;
  final ValueChanged<bool>? onCompareToggle;
  final String? imageFallbackAsset;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.isSelectedForCompare = false,
    this.onCompareToggle,
    this.imageFallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    final price = product.dealPrice ?? product.basePrice;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _CatalogImage(
                      imageUrl: product.thumbnailUrl,
                      fallbackAsset: imageFallbackAsset,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        onCompareToggle?.call(!isSelectedForCompare);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelectedForCompare ? const Color(0xFF2A66FF) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(
                          Icons.compare_arrows,
                          size: 16,
                          color: isSelectedForCompare ? Colors.white : Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A66FF),
                  ),
                ),
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A66FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogImage extends StatelessWidget {
  final String imageUrl;
  final String? fallbackAsset;
  final double? width;
  final double? height;

  const _CatalogImage({
    required this.imageUrl,
    this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildFallback();
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  Widget _buildFallback() {
    if (fallbackAsset != null && fallbackAsset!.isNotEmpty) {
      return Image.asset(fallbackAsset!, fit: BoxFit.cover);
    }
    return Container(color: Colors.grey.shade200);
  }
}

