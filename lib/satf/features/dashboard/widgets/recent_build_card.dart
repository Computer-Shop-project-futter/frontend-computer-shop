import 'package:flutter/material.dart';
import '../models/recent_build_model.dart';
import '../app_theme.dart';

class RecentBuildCard extends StatelessWidget {
  final RecentBuildModel pcBuild;
  final VoidCallback? onTap;

  const RecentBuildCard({
    super.key,
    required this.pcBuild,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Left: Icon Box ─────────────────────────────
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.computer_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            // ── Center: Info ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${pcBuild.id}',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pcBuild.title,
                    style: AppTextStyles.headingSmall.copyWith(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.memory_outlined,
                        size: 11,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          pcBuild.specs,
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // ── Right: Price + Arrow ───────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${pcBuild.estimatedPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}