// ─────────────────────────────────────────────
//  G14 Admin — Top Products Card
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../data/app_theme.dart';
import '../../models/models.dart';
import 'section_card.dart';

class TopProductsCard extends StatelessWidget {
  final VoidCallback? onViewAll;
  const TopProductsCard({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final products = AppData.topProducts;

    return SectionCard(
      title: 'Top Products',
      trailing: onViewAll == null
          ? const Text(
              'THIS MONTH',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
                letterSpacing: 0.5,
              ),
            )
          : TextButton(
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
        children: products
            .map((p) => _ProductRow(product: p))
            .toList(),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final Product product;
  const _ProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              product.rank,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Text(
            product.price,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentDark,
            ),
          ),
        ],
      ),
    );
  }
}
