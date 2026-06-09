// ─────────────────────────────────────────────
//  G14 Admin — Recent Orders Card
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/app_data.dart';
import '../../../data/app_theme.dart';
import '../../../models/models.dart';
import '../order/popupOrderPage.dart';
import 'section_card.dart';

class RecentOrdersCard extends StatelessWidget {
  final VoidCallback? onViewAll;
  const RecentOrdersCard({super.key, required this.onViewAll});

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

    return InkWell(
      onTap: () {
        showOrderPopup(context, order as OrderDetail);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(status: order.status),
        ],
      ),
    )
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPaid = status == OrderStatus.paid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: isPaid ? AppTheme.paidBg : AppTheme.pendingBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaid ? 'PAID' : 'PENDING',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isPaid ? AppTheme.paidText : AppTheme.pendingText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
