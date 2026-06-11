// ─────────────────────────────────────────────
//  G14 Admin — Home Shell (Sidebar + BottomNav)
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'data/app_theme.dart';
import 'widgets/category/components_screen.dart';
import 'widgets/dashboard/dashboard_screen.dart';
import 'widgets/order/orders_screen.dart';
import 'widgets/sidebar/app_sidebar.dart' show AppSidebar;

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  String _activePage = 'Dashboard Overview';
  int _bottomNavIndex = 0;

  // ── Page builder (extend as you add screens) ──
  Widget _buildPage(bool isWide) {
    final pageIndex = isWide ? _pageIndexForLabel(_activePage) : _bottomNavIndex;

    switch (pageIndex) {
      case 1:
        return OrdersScreen(onMenuTap: _openDrawer);
      case 2:
        return ComponentsScreen(onMenuTap: _openDrawer);
      case 3:
        return _PlaceholderScreen(
          title: 'Metrics',
          onMenuTap: _openDrawer,
        );
      case 4:
        return _PlaceholderScreen(
          title: _activePage,
          onMenuTap: _openDrawer,
        );
      case 0:
      default:
        return DashboardScreen(
          onMenuTap: _openDrawer,
          onNavigateToOrders: _routeToOrders,
          onNavigateToProducts: _routeToProducts,
        );
    }
  }

  int _pageIndexForLabel(String label) {
    switch (label) {
      case 'Orders':
      case 'Order Fulfillment':
        return 1;
      case 'Master Catalog':
      case 'Global Products':
      case 'Precision Components':
      case 'Partner Brands':
      case 'Inventory':
        return 2;
      case 'Metrics':
      case 'Feedback':
      case 'Promotion':
      case 'Coupon Points':
        return 4;
      case 'Dashboard Overview':
      default:
        return 0;
    }
  }

  String _pageLabelForIndex(int index) {
    switch (index) {
      case 1:
        return 'Order Fulfillment';
      case 2:
        return 'Master Catalog';
      case 3:
        return 'Metrics';
      case 0:
      default:
        return 'Dashboard Overview';
    }
  }

  void _routeToOrders() {
    setState(() {
      _bottomNavIndex = 1;
      _activePage = 'Order Fulfillment';
    });
  }

  void _routeToProducts() {
    setState(() {
      _bottomNavIndex = 2;
      _activePage = 'Master Catalog';
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.bgPage,

      // ── Mobile drawer ─────────────────────────
      drawer: isWide
          ? null
          : Drawer(
              width: 240,
              backgroundColor: AppTheme.sidebarBg,
              child: AppSidebar(
                activePage: _activePage,
                onPageSelected: (page) {
                  setState(() => _activePage = page);
                },
              ),
            ),

      body: Row(
        children: [
          // ── Desktop sidebar ───────────────────
          if (isWide)
            AppSidebar(
              activePage: _activePage,
              onPageSelected: (page) => setState(() => _activePage = page),
            ),

          // ── Main content ──────────────────────
          Expanded(child: _buildPage(isWide)),
        ],
      ),

      // ── Bottom navigation (mobile) ────────────
      bottomNavigationBar: isWide ? null : _BottomNav(
        selectedIndex: _bottomNavIndex,
        onTap: (i) => setState(() {
          _bottomNavIndex = i;
          _activePage = _pageLabelForIndex(i);
        }),
        labels: AppData.bottomNavLabels,
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final VoidCallback onMenuTap;

  const _PlaceholderScreen({
    required this.title,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
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
                if (MediaQuery.of(context).size.width < 900)
                  IconButton(
                    onPressed: onMenuTap,
                    icon: const Icon(Icons.menu_rounded),
                    color: AppTheme.textPrimary,
                  ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$title page is coming soon.',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom nav bar ────────────────────────────
class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  const _BottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: List.generate(
              labels.length,
              (i) => Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _iconFor(i),
                        size: 20,
                        color: selectedIndex == i
                            ? AppTheme.accent
                            : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: selectedIndex == i
                              ? AppTheme.accent
                              : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(int index) {
    switch (index) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.receipt_long_outlined;
      case 2:
        return Icons.category_outlined;
      case 3:
        return Icons.bar_chart_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
