import 'package:flutter/material.dart';
import '../../../app/router/app_router.dart';

class AppTextFooter extends StatelessWidget {
  final String text;

  const AppTextFooter({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class AppNavigationFooter extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppNavigationFooter({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFE8EEFF),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                color: selected
                    ? const Color(0xFF2A66FF)
                    : const Color(0xFF7A8090),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected
                    ? const Color(0xFF2A66FF)
                    : const Color(0xFF7A8090),
                size: 22,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              // Map index to routes
              switch (index) {
                case 0:
                  AppRouter.router.go('/home');
                  break;
                case 1:
                  AppRouter.router.go('/products');
                  break;
                case 2:
                  AppRouter.router.go('/wishlist'); // Changed from builder to wishlist
                  break;
                case 3:
                  AppRouter.router.go('/builder');
                  break;
                case 4:
                  AppRouter.router.go('/repair');
                  break;
                case 5:
                  AppRouter.router.go('/account');
                  break;
              }
              onTabSelected(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_rounded),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Browse',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_rounded), // Wishlist icon
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Wishlist',
              ),
              NavigationDestination(
                icon: Icon(Icons.developer_board_outlined),
                selectedIcon: Icon(Icons.developer_board_rounded),
                label: 'Builder',
              ),
              NavigationDestination(
                icon: Icon(Icons.build_outlined),
                selectedIcon: Icon(Icons.build_rounded),
                label: 'Repair',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}