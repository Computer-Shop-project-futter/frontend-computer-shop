// ─────────────────────────────────────────────
//  G14 Admin — Order Status Badge
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../data/app_theme.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final double fontSize;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.statusBg(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: AppTheme.statusFg(status),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
