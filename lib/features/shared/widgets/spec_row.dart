import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Specification row widget
/// Single row for specs table
class SpecRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlternate;

  const SpecRow({
    super.key,
    required this.label,
    required this.value,
    this.isAlternate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isAlternate ? AppColors.kSurface : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.kSecondaryText,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
