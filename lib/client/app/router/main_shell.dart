// lib/app/router/main_shell.dart
// Persistent shell layout that wraps all main pages with a shared Scaffold,
// header, footer navigation bar, and drawer. Only the body content changes
// when navigating between routes.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/shared/footer/app_footer.dart';
import '../../features/shared/header/app_main_header.dart';
import '../../features/shared/widgets/navigation/app_drawer.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainShell({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  /// Map main routes to their bottom nav index.
  static int indexForRoute(String path) {
    if (path.startsWith('/home')) return 0;
    if (path.startsWith('/products')) return 1;
    if (path.startsWith('/builder')) return 2;
    if (path.startsWith('/repair')) return 3;
    if (path.startsWith('/account')) return 4;
    // Default to 0 for other main routes like /cart, /wishlist, /chat, etc.
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Persistent header
            AppMainHeader(
              dark: true,
              showSearch: true,
              showFavorites: false,
              showCart: false,
              showChat: true,
              onSearchPressed: () => _showSearchModal(context),
              onChatPressed: () => context.go('/chat'),
            ),
            // Page content
            Expanded(child: child),
            // Persistent bottom navigation
            AppNavigationFooter(
              currentIndex: currentIndex,
              onTabSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/products');
                    break;
                  case 2:
                    context.go('/builder');
                    break;
                  case 3:
                    context.go('/repair');
                    break;
                  case 4:
                    context.go('/account');
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}