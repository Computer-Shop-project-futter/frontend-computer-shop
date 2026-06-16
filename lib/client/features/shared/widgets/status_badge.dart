import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Status badge widget
/// Pill-shaped badge for order and ticket status
class StatusBadge extends StatelessWidget {
  final String status;
  final Color? backgroundColor;
  final Color? textColor;

  const StatusBadge({
    super.key,
    required this.status,
    this.backgroundColor,
    this.textColor,
  });

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    switch (status.toLowerCase()) {
      case 'paid':
      case 'ready':
      case 'completed':
        return AppColors.kDark;
      case 'pending':
      case 'processing':
      case 'in_progress':
        return Colors.transparent;
      case 'cancelled':
      case 'rejected':
        return AppColors.kDisabledBackground;
      default:
        return AppColors.kSurface;
    }
  }

  Color _getTextColor() {
    if (textColor != null) return textColor!;

    switch (status.toLowerCase()) {
      case 'paid':
      case 'ready':
      case 'completed':
        return AppColors.kBackground;
      case 'pending':
      case 'processing':
      case 'in_progress':
        return AppColors.kPrimaryText;
      case 'cancelled':
      case 'rejected':
        return AppColors.kDisabledText;
      default:
        return AppColors.kPrimaryText;
    }
  }

  BorderSide? _getBorder() {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'processing':
      case 'in_progress':
        return const BorderSide(color: AppColors.kPrimaryText, width: 1);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: _getBorder() != null ? Border.all(color: _getBorder()!.color) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(
          color: _getTextColor(),
        ),
      ),
    );
  }
}
