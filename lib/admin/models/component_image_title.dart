// ─────────────────────────────────────────────
//  G14 Admin — Component Image / Icon Tile
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/models.dart';

class ComponentImageTile extends StatelessWidget {
  final ComponentCategory category;
  final double size;

  const ComponentImageTile({
    super.key,
    required this.category,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: _icon()),
    );
  }

  Widget _icon() {
    final iconData = _iconFor(category);
    final color = category.badgeColor.withOpacity(0.7);
    return Icon(iconData, size: size * 0.48, color: color);
  }

  IconData _iconFor(ComponentCategory cat) {
    switch (cat) {
      case ComponentCategory.cpu:     return Icons.memory_rounded;
      case ComponentCategory.gpu:     return Icons.videocam_outlined;
      case ComponentCategory.ram:     return Icons.view_column_outlined;
      case ComponentCategory.storage: return Icons.storage_rounded;
      case ComponentCategory.mb:      return Icons.developer_board_rounded;
      default:                        return Icons.devices_other_rounded;
    }
  }
}