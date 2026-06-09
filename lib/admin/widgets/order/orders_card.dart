// ─────────────────────────────────────────────
//  G14 Admin — Recent Orders Card (Dashboard)
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../data/app_data.dart';
import '../../../data/app_theme.dart';
import '../../../models/models.dart';
import '../dashboard/section_card.dart';
import 'order_status_badge.dart';


class RecentOrdersCard extends StatelessWidget {
  /// Called when "View All" is tapped — switches bottom nav to Orders tab
  final VoidCallback? onViewAll;

  const RecentOrdersCard({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final orders = AppData.recentOrders;

    return SectionCard(
      title: 'Recent Orders',
      trailing: TextButton(
        onPressed: onViewAll,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'View All',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.accent,
          ),
        ),
      ),
      child: Column(
        children: orders.map((o) => _OrderRow(order: o)).toList(),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final Order order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${order.timeAgo} · ${order.category}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          OrderStatusBadge(status: order.status),
        ],
      ),
    );
  }
}
