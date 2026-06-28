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

      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            metric.label.toUpperCase(),
            style: const TextStyle(

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

              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 1),

          Row(
            children: [
              Icon(
                metric.isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,

                size: 11,

                color: metric.isPositive ? AppTheme.green : AppTheme.red,
              ),
              const SizedBox(width: 2),
              Text(
                metric.change,
                style: TextStyle(

                  fontSize: 11,

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
