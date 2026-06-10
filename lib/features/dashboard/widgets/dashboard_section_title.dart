import 'package:flutter/material.dart';
import '../app_theme.dart';

class DashboardSectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const DashboardSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left accent bar
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: AppTextStyles.headingSmall),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}