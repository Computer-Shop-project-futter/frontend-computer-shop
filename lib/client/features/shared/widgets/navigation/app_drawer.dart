import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:computer_shop/auth/presentation/providers/auth_provider.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  String _selectedActivity = 'builds';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Drawer(
      backgroundColor: AppColors.kBackground,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSection(user),
                  const SizedBox(height: 24),
                  _buildPostMessageButton(),
                  const SizedBox(height: 24),
                  _buildShopByCategory(),
                  const SizedBox(height: 32),
                  _buildMyActivity(),
                ],
              ),
            ),
          ),
          _buildFooterSection(context, authState),
        ],
      ),
    );
  }

  Widget _buildProfileSection(user) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kSurface,
              border: Border.all(color: AppColors.kBorder, width: 2),
            ),
            child: user?.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      user!.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.person, size: 40, color: AppColors.kSecondaryText),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Icon(Icons.person, size: 40, color: AppColors.kSecondaryText),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.fullName ?? 'Tech Enthusiast',
            style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'OS Elite Member',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.kSecondaryText),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.kBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 14, color: Color(0xFFFFB800)),
                const SizedBox(width: 6),
                Text(
                  '1,240 Points',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.kPrimaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostMessageButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B67CA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: Text(
            'POST MESSAGE',
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildShopByCategory() {
    final categories = [
      ('Laptops', Icons.laptop),
      ('Desktops', Icons.desktop_mac),
      ('Components', Icons.memory),
      ('Peripherals', Icons.mouse),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHOP BY CATEGORY',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.kSecondaryText,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...categories.map((category) {
            return _buildCategoryItem(category.$1, category.$2);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.kSecondaryText),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.kPrimaryText)),
          ],
        ),
      ),
    );
  }

  Widget _buildMyActivity() {
    final activityItems = [
      ('builds', 'My Builds', Icons.build),
      ('wishlist', 'Wishlist', Icons.favorite_border),
      ('coupon', 'Coupons', Icons.local_offer),
      ('orders', 'Order History', Icons.receipt),
      ('chat', 'Support Chat', Icons.chat_bubble_outline),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MY ACTIVITY',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.kSecondaryText,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...activityItems.map((item) {
            return _buildActivityItem(id: item.$1, label: item.$2, icon: item.$3);
          }),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String id,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedActivity == id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedActivity = id;
          });
          Navigator.pop(context);
          if (id == 'builds') {
            context.go('/builder');
          } else if (id == 'wishlist') {
            context.go('/wishlist');
          } else if (id == 'coupon') {
            context.go('/coupon');
          } else if (id == 'orders') {
            context.go('/account');
          } else if (id == 'chat') {
            context.go('/chat');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5B67CA).withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? const Color(0xFF5B67CA) : AppColors.kSecondaryText,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? const Color(0xFF5B67CA) : AppColors.kPrimaryText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context, AuthState authState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.kBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'v2.4.1',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.kSecondaryText),
          ),
          const SizedBox(height: 12),
          _buildFooterMenuItem('Legal Information', Icons.description_outlined, () {
            Navigator.pop(context);
          }),
          const SizedBox(height: 12),
          _buildFooterMenuItem('Support Chat', Icons.chat_bubble_outline, () {
            Navigator.pop(context);
            context.go('/chat');
          }),
          const SizedBox(height: 12),
          _buildFooterMenuItem('Account Settings', Icons.settings_outlined, () {
            Navigator.pop(context);
          }),
          const SizedBox(height: 12),
          _buildFooterMenuItem('Support', Icons.help_outline, () {
            Navigator.pop(context);
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 18, color: AppColors.kError),
                  const SizedBox(width: 12),
                  Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.kError,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterMenuItem(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.kSecondaryText),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.kPrimaryText)),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Logout', style: AppTextStyles.headingSmall),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.kSecondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kError,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}