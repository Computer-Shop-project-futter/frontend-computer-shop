// ─────────────────────────────────────────────
//  G14 Admin — Metric Card
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../data/app_theme.dart';
import '../../models/models.dart';

class MetricCard extends StatelessWidget {
  final MetricItem metric;

  const MetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
<<<<<<< HEAD
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
=======
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
>>>>>>> 4bf4199 (update code in client and admin)
        children: [
          Text(
            metric.label.toUpperCase(),
            style: const TextStyle(
<<<<<<< HEAD
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 22,
=======
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 20,
>>>>>>> 4bf4199 (update code in client and admin)
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
<<<<<<< HEAD
          const SizedBox(height: 2),
=======
          const SizedBox(height: 1),
>>>>>>> 4bf4199 (update code in client and admin)
          Row(
            children: [
              Icon(
                metric.isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
<<<<<<< HEAD
                size: 13,
=======
                size: 11,
>>>>>>> 4bf4199 (update code in client and admin)
                color: metric.isPositive ? AppTheme.green : AppTheme.red,
              ),
              const SizedBox(width: 2),
              Text(
                metric.change,
                style: TextStyle(
<<<<<<< HEAD
                  fontSize: 12,
=======
                  fontSize: 11,
>>>>>>> 4bf4199 (update code in client and admin)
                  fontWeight: FontWeight.w600,
                  color: metric.isPositive ? AppTheme.green : AppTheme.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
