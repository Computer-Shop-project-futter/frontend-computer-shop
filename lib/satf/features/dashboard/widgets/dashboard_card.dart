import 'package:flutter/material.dart';
import '../app_theme.dart';

class DashboardCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final String? trend;     // e.g. "+2%" — null hides it
  final bool trendUp;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.iconBgColor,
    this.trend,
    this.trendUp = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? AppColors.primary;
    final resolvedIconBg = iconBgColor ?? AppColors.primarySoft;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ──────────────────────────────────────
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: resolvedIconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: resolvedIconColor),
            ),
            const SizedBox(height: 12),
            // ── Value ─────────────────────────────────────
            Text(value, style: AppTextStyles.statNumber),
            const SizedBox(height: 2),
            // ── Label + Trend ─────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trend != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: trendUp
                          ? AppColors.successSoft
                          : AppColors.errorSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      trend!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: trendUp ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}