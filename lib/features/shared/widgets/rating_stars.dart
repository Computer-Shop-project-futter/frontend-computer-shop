import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Rating stars widget
/// Displays 1-5 stars filled proportionally
class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            final fillPercentage = (rating - index).clamp(0.0, 1.0);
            return Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.star_outline, size: size, color: AppColors.kBorder),
                ClipRect(
                  clipper: _StarClipper(fillPercentage),
                  child: Icon(
                    Icons.star,
                    size: size,
                    color: AppColors.kDark,
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
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
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fillPercentage;

  _StarClipper(this.fillPercentage);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fillPercentage, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return oldClipper.fillPercentage != fillPercentage;
  }
}
