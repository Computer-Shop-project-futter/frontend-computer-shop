import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Bottom navigation bar widget
/// Fixed 64px bottom nav with 4 tabs
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.kBackground,
        border: Border(
          top: BorderSide(color: AppColors.kBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            icon: Icons.home,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _NavItem(
            icon: Icons.shopping_bag,
            label: 'Products',
            isActive: currentIndex == 1,
            onTap: () => onTabChanged(1),
          ),
          _NavItem(
            icon: Icons.build,
            label: 'Builder',
            isActive: currentIndex == 2,
            onTap: () => onTabChanged(2),
          ),
          _NavItem(
            icon: Icons.person,
            label: 'Account',
            isActive: currentIndex == 3,
            onTap: () => onTabChanged(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.kDark : AppColors.kSecondaryText,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? AppColors.kDark : AppColors.kSecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
