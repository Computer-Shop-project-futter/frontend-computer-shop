// ─────────────────────────────────────────────
//  G14 Admin — Orders Metrics Bar
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../data/app_theme.dart';


class OrdersMetricsBar extends StatelessWidget {
  const OrdersMetricsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MetricData(label: 'TOTAL ORDERS',    value: AppData.ordersTotalOrders),
      _MetricData(label: "TODAY'S REVENUE", value: AppData.ordersTodayRevenue),
      _MetricData(label: 'MONTH',           value: AppData.ordersMonthRevenue),
    ];

    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: items.map((item) {
          final isLast = item == items.last;
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: isLast
                      ? BorderSide.none
                      : const BorderSide(color: AppTheme.borderColor),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accent,
                      letterSpacing: -0.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  const _MetricData({required this.label, required this.value});
}
