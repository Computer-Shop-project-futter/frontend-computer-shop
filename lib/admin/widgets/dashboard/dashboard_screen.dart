// ─────────────────────────────────────────────
//  G14 Admin — Dashboard Screen
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../data/app_theme.dart';
import '../../models/models.dart';
import '../../inventory_alerts_card.dart';
import 'metric_card.dart';
import 'top_products_card.dart';
import 'recent_orders_card.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onMenuTap;
  /// Called when "View All" tapped on recent orders → switches to Orders tab
  final VoidCallback? onNavigateToOrders;
  /// Called when "View All" tapped on top products → navigates to Products/Inventory
  final VoidCallback? onNavigateToProducts;
  
  const DashboardScreen({
    super.key,
    required this.onMenuTap,
    required this.onNavigateToOrders,
    this.onNavigateToProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: Column(
        children: [
          // ── Sticky header ─────────────────────
          _DashboardHeader(onMenuTap: onMenuTap),

          // ── Scrollable content ────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 2×2 Metrics grid
                  _MetricsGrid(metrics: AppData.metrics),

                  const SizedBox(height: 12),

                  // Cards
                  TopProductsCard(onViewAll: onNavigateToProducts),
                  RecentOrdersCard(onViewAll: onNavigateToOrders),
                  // const RecentOrdersCard(),
                  const InventoryAlertsCard(),

                  const SizedBox(height: 80), // bottom nav clearance
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ── Header ────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _DashboardHeader({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          // Menu button (hidden on wide screens)
          if (MediaQuery.of(context).size.width < 900)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded),
              color: AppTheme.textPrimary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 22,
            ),

          const SizedBox(width: 8),

          // G14 mini badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'G14',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),

          const Spacer(),

          // User avatar
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'AR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Metrics grid ──────────────────────────────
class _MetricsGrid extends StatelessWidget {
  final List<MetricItem> metrics;
  const _MetricsGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemCount: metrics.length,
        itemBuilder: (_, i) => MetricCard(metric: metrics[i]),
      ),
    );
  }
}
