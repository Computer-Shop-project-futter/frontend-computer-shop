// ─────────────────────────────────────────────
//  G14 Admin — Component Card
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/component_image_title.dart';
import '../../models/models.dart';


class ComponentCard extends StatelessWidget {
  final ComponentItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleVisibility;

  const ComponentCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final isHidden = !item.isVisible;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: isHidden
            ? const Color(0xFFFAFAFA)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHidden
              ? const Color(0xFFF0F0F0)
              : const Color(0xFFEFF2F6),
          width: 1,
        ),
        boxShadow: isHidden
            ? []
            : const [
                BoxShadow(
                  color: Color(0x09000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // ── Product image ───────────────────
          Opacity(
            opacity: isHidden ? 0.45 : 1.0,
            child: ComponentImageTile(category: item.category),
          ),

          const SizedBox(width: 14),

          // ── Name / brand / price ────────────
          Expanded(
            child: Opacity(
              opacity: isHidden ? 0.5 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + category badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: -0.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _CategoryBadge(category: item.category),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.brand,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 6),

          // ── Action buttons ──────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit (hidden if item is not visible)
              if (!isHidden)
                _ActionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF3B82F6),
                  onTap: onEdit,
                ),

              // Visibility toggle
              _ActionButton(
                icon: isHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_off_outlined,
                color: isHidden
                    ? const Color(0xFFD1D5DB)
                    : const Color(0xFFD1D5DB),
                onTap: onToggleVisibility,
              ),

              const SizedBox(height: 2),

              // Delete
              _ActionButton(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444),
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Small icon action button ──────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 19, color: color),
      ),
    );
  }
}

// ── Category badge pill ───────────────────────
class _CategoryBadge extends StatelessWidget {
  final ComponentCategory category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    if (category == ComponentCategory.all) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: category.badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category.label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: category.badgeColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}