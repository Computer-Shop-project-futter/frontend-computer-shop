// lib/features/wishlist/presentation/widgets/wishlist_category_chips.dart

import 'package:flutter/material.dart';

class WishlistCategoryChips extends StatelessWidget {
  final Set<String> selectedFilters;
  final int productCount;
  final int buildCount;
  final Function(String) onFilterTap;

  const WishlistCategoryChips({
    super.key,
    required this.selectedFilters,
    required this.productCount,
    required this.buildCount,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // All Products Chip
          _CategoryChip(
            label: 'All Products',
            icon: Icons.grid_view_rounded,
            isSelected: selectedFilters.isEmpty,
            onTap: () {
              // Clear all filters
              for (final filter in selectedFilters.toList()) {
                onFilterTap(filter);
              }
            },
          ),
          const SizedBox(width: 10),

          // Products Chip
          _CategoryChip(
            label: 'Products ($productCount)',
            icon: Icons.inventory_2_rounded,
            isSelected: selectedFilters.contains('products'),
            onTap: () => onFilterTap('products'),
          ),
          const SizedBox(width: 10),

          // Saved Builds Chip
          _CategoryChip(
            label: 'Saved Builds ($buildCount)',
            icon: Icons.build_rounded,
            isSelected: selectedFilters.contains('builds'),
            onTap: () => onFilterTap('builds'),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A66FF) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? const Color(0xFF2A66FF) : const Color(0xFFE3E9F5),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2A66FF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF6B7891),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF10213B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}