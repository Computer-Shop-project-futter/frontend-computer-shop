// ─────────────────────────────────────────────
//  G14 Admin — Inventory Alerts Card
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'data/app_theme.dart';
import '../admin/models/models.dart';
import 'widgets/dashboard/section_card.dart';

class InventoryAlertsCard extends StatelessWidget {
  const InventoryAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = AppData.inventoryAlerts;

    return SectionCard(
      title: 'Inventory Alerts',
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.pendingBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${alerts.length} ACTION REQUIRED',
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: AppTheme.pendingText,
            letterSpacing: 0.4,
          ),
        ),
      ),
      child: Column(
        children: alerts.map((a) => _AlertRow(alert: a)).toList(),
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final InventoryAlert alert;
  const _AlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppTheme.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.productName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  alert.warehouse,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${alert.stockLeft} LEFT',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
