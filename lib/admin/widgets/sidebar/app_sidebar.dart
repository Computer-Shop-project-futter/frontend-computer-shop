// ─────────────────────────────────────────────
//  G14 Admin — Sidebar
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/app_data.dart';
import '../../../data/app_theme.dart';
import '../../../models/models.dart';

class AppSidebar extends StatelessWidget {
  final String activePage;
  final ValueChanged<String> onPageSelected;

  const AppSidebar({
    super.key,
    required this.activePage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      width: 240,
      color: AppTheme.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Safe area top padding
          SizedBox(height: MediaQuery.of(context).padding.top),

          // ── Brand ──────────────────────────────
          _BrandHeader(),

          // ── User ───────────────────────────────
          _UserTile(user: AppData.currentUser),

          // ── Navigation ─────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AppData.navSections
                    .map((section) => _NavSection(
                          section: section,
                          activePage: activePage,
                          onPageSelected: (label) {
                            onPageSelected(label);
                            // Close drawer on mobile
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                        ))
                    .toList(),
              ),
            ),
          ),

          // ── Terminate Session ───────────────────
          _TerminateButton(),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// ── Brand header ─────────────────────────────
class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.sidebarBorder),
        ),
      ),
      child: Row(
        children: [
          _G14Badge(),
          const SizedBox(width: 10),
          const Text(
            'G14',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _G14Badge extends StatelessWidget {
  final double fontSize;
  const _G14Badge({this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'G14',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── User tile ─────────────────────────────────
class _UserTile extends StatelessWidget {
  final AdminUser user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.sidebarBorder),
        ),
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppTheme.sidebarAvatar,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Color(0xFF9CA3C8),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.role,
                style: const TextStyle(
                  color: AppTheme.sidebarMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Nav section ───────────────────────────────
class _NavSection extends StatelessWidget {
  final NavSection section;
  final String activePage;
  final ValueChanged<String> onPageSelected;

  const _NavSection({
    required this.section,
    required this.activePage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
          child: Text(
            section.sectionLabel,
            style: const TextStyle(
              color: AppTheme.sidebarMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
        ...section.items.map((item) => _NavItemTile(
              item: item,
              isActive: activePage == item.label,
              onTap: () => onPageSelected(item.label),
            )),
      ],
    );
  }
}

// ── Individual nav item ───────────────────────
class _NavItemTile extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(
          left: item.isSubItem ? 44 : 18,
          right: 18,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.sidebarActive : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isActive ? AppTheme.accent : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            if (!item.isSubItem && item.iconAsset != null) ...[
              _NavIcon(iconName: item.iconAsset!),
              const SizedBox(width: 10),
            ],
            Text(
              item.label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : item.isSubItem
                        ? AppTheme.sidebarMuted
                        : AppTheme.sidebarText,
                fontSize: item.isSubItem ? 12.5 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Icon widget using built-in Flutter icons ──
class _NavIcon extends StatelessWidget {
  final String iconName;
  const _NavIcon({required this.iconName});

  IconData _resolve() {
    switch (iconName) {
      case 'dashboard':
        return Icons.grid_view_rounded;
      case 'catalog':
        return Icons.layers_outlined;
      case 'settings':
        return Icons.settings_outlined;
      case 'users':
        return Icons.people_outline;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(_resolve(), color: AppTheme.sidebarText, size: 16);
  }
}

// ── Terminate session button ──────────────────
class _TerminateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1E2E),
            border: Border.all(color: const Color(0xFF2A2F42)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: AppTheme.sidebarText, size: 14),
              SizedBox(width: 8),
              Text(
                'Terminate Session',
                style: TextStyle(
                  color: AppTheme.sidebarText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
