import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Price tag widget
/// Displays price with deal styling if applicable
class PriceTag extends StatelessWidget {
  final double basePrice;
  final double? dealPrice;
  final bool showStrikethrough;

  const PriceTag({
    super.key,
    required this.basePrice,
    this.dealPrice,
    this.showStrikethrough = true,
  });

  @override
  Widget build(BuildContext context) {
    if (dealPrice != null && showStrikethrough) {
      return Row(
        children: [
          Text(
            '\$${basePrice.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.kSecondaryText,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${dealPrice!.toStringAsFixed(2)}',
            style: AppTextStyles.dealPriceStyle,
          ),
        ],
      );
    }

    return Text(
      '\$${(dealPrice ?? basePrice).toStringAsFixed(2)}',
      style: AppTextStyles.priceStyle,
    );
  }
}
