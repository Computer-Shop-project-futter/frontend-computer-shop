import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Benchmark bar widget
/// Full-width benchmark bar with label, score, and fill percentage
class BenchmarkBar extends StatelessWidget {
  final String label;
  final double score;
  final double barPercent;
  final String? unit;

  const BenchmarkBar({
    super.key,
    required this.label,
    required this.score,
    required this.barPercent,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                '${score.toStringAsFixed(1)}${unit != null ? ' $unit' : ''}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (barPercent / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.kBorder,
              valueColor: AlwaysStoppedAnimation(AppColors.kDark),
            ),
          ),
        ],
      ),
    );
  }
}
