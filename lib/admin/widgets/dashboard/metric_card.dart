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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label.toUpperCase(),
            style: const TextStyle(
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
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                metric.isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 13,
                color: metric.isPositive ? AppTheme.green : AppTheme.red,
              ),
              const SizedBox(width: 2),
              Text(
                metric.change,
                style: TextStyle(
                  fontSize: 12,
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
