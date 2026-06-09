// ─────────────────────────────────────────────
//  G14 Admin — Order Card (list item)
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/app_theme.dart';
import '../../../models/models.dart';
import 'order_status_badge.dart';


class OrderCard extends StatelessWidget {
  final OrderDetail order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: ID + Status ─────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),

            const SizedBox(height: 6),

            // ── Row 2: Customer name ───────────
            Text(
              order.customerName,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 2),

            // ── Row 3: Date + Coupon ───────────
            Text(
              '${order.date} • ${order.coupon}',
              style: const TextStyle(
                fontSize: 11.5,
                color: AppTheme.textMuted,
              ),
            ),

            const SizedBox(height: 10),

            const Divider(height: 1, color: AppTheme.borderColor),

            const SizedBox(height: 10),

            // ── Row 4: Items count + Price + Arrow ─
            Row(
              children: [
                Text(
                  '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  order.totalAmount,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.bgPage,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
