// lib/features/account/presentation/pages/account_page.dart

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:computer_shop/client/features/account/domain/account_model.dart';
import 'package:computer_shop/client/features/account/widgets/address_card.dart';
import 'package:computer_shop/client/features/account/widgets/order_card.dart';
import 'package:computer_shop/client/features/account/widgets/profile_header.dart';
import 'package:computer_shop/client/features/account/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/account_provider.dart';



class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);
    final notifier = ref.read(accountProvider.notifier);

    return Column(
      children: [
        Expanded(
            child: accountState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => notifier.loadAccountData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        children: [
                          // Profile Header
                          if (accountState.user != null)
                            ProfileHeader(
                              user: accountState.user!,
                              onEditProfile: () {
                                _showEditProfileDialog(context, ref, accountState.user!);
                              },
                            ),
                          const SizedBox(height: 20),

                          // Stats Cards
                          _StatsRow(
                            orderCount: accountState.recentOrders.length,
                            wishlistCount: 12,
                            addressCount: accountState.addresses.length,
                          ),
                          const SizedBox(height: 20),

                          // Tab Selector
                          _TabSelector(
                            selectedIndex: accountState.selectedTabIndex,
                            onTabSelected: notifier.setSelectedTab,
                          ),
                          const SizedBox(height: 16),

                          // Tab Content
                          _TabContent(
                            selectedIndex: accountState.selectedTabIndex,
                            recentOrders: accountState.recentOrders,
                            addresses: accountState.addresses,
                          ),
                          const SizedBox(height: 16),

                          // Settings Section
                          const _SettingsSection(),
                          const SizedBox(height: 20),

                          // Logout Button
                          _LogoutButton(
                            onLogout: () async {
                              await notifier.logout();
                              if (mounted) {
                                context.go('/login');
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
          ),

        ],
      );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserProfile user) {
    final nameController = TextEditingController(text: user.fullName);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final formKey = GlobalKey<FormState>();
    XFile? selectedImage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Profile'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar picker
                GestureDetector(
                  onTap: () async {
                    final source = await showModalBottomSheet<ImageSource>(
                      context: dialogContext,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      builder: (context) => SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Choose Avatar Source',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt_outlined),
                                title: const Text('Camera'),
                                onTap: () => Navigator.pop(context, ImageSource.camera),
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library_outlined),
                                title: const Text('Gallery'),
                                onTap: () => Navigator.pop(context, ImageSource.gallery),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    if (source != null) {
                      final image = await ref.read(accountProvider.notifier).pickImage(source);
                      if (image != null) {
                        setDialogState(() {
                          selectedImage = image;
                        });
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          image: selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(File(selectedImage!.path)),
                                  fit: BoxFit.cover,
                                )
                              : (user.avatarUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(user.avatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                        ),
                        child: selectedImage == null && user.avatarUrl == null
                            ? const Icon(Icons.person, size: 40, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 12,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A66FF),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  await ref.read(accountProvider.notifier).updateProfile(
                    fullName: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    avatarFile: selectedImage,
                  );
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated!'),
                        backgroundColor: Color(0xFF2A66FF),
                      ),
                    );
                  }
                } catch (error) {
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Unable to update profile: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A66FF),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// Stats Row Widget
class _StatsRow extends StatelessWidget {
  final int orderCount;
  final int wishlistCount;
  final int addressCount;

  const _StatsRow({
    required this.orderCount,
    required this.wishlistCount,
    required this.addressCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.shopping_bag_outlined,
            label: 'Orders',
            value: orderCount.toString(),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.favorite_border,
            label: 'Wishlist',
            value: wishlistCount.toString(),
            onTap: () => context.go('/wishlist'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.location_on_outlined,
            label: 'Addresses',
            value: addressCount.toString(),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2A66FF), size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF10213B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7891),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab Selector
class _TabSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const _TabSelector({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'Orders',
            isSelected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          _TabButton(
            label: 'Addresses',
            isSelected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          _TabButton(
            label: 'Settings',
            isSelected: selectedIndex == 2,
            onTap: () => onTabSelected(2),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2A66FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF6B7891),
            ),
          ),
        ),
      ),
    );
  }
}

// Tab Content
class _TabContent extends StatelessWidget {
  final int selectedIndex;
  final List<Order> recentOrders;
  final List<Address> addresses;

  const _TabContent({
    required this.selectedIndex,
    required this.recentOrders,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return recentOrders.isEmpty
            ? _EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'No Orders Yet',
                subtitle: 'Your order history will appear here',
              )
            : Column(
                children: recentOrders.map((order) => OrderCard(order: order)).toList(),
              );
      case 1:
        return addresses.isEmpty
            ? _EmptyState(
                icon: Icons.location_on_outlined,
                title: 'No Addresses',
                subtitle: 'Add your first shipping address',
              )
            : Column(
                children: addresses.map((address) => AddressCard(address: address)).toList(),
              );
      case 2:
        return const _SettingsContent();
      default:
        return const SizedBox.shrink();
    }
  }
}

// Settings Section
class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'QUICK SETTINGS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Color(0xFF6B7891),
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your alerts',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            subtitle: 'Password, 2FA, and more',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQs, contact us',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Name, email, phone number',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Email and push notifications',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Manage saved cards',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.data_usage_outlined,
            title: 'Privacy',
            subtitle: 'Data and privacy settings',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const _LogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onLogout,
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          'SIGN OUT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEF4444),
          side: const BorderSide(color: Color(0xFFEF4444)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: const Color(0xFF6B7891)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF10213B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7891),
            ),
          ),
        ],
      ),
    );
  }
}

