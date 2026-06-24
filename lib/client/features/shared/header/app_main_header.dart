import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_header.dart';

/// Main header widget that includes drawer menu and consistent branding
/// This header is designed to be used across all main pages
class AppMainHeader extends StatelessWidget {
  /// Whether to show dark theme (blue gradient)
  final bool dark;
  
  /// Page title (shown on light header)
  final String? title;
  
  /// Show back button instead of menu
  final bool showBack;
  
  /// Callback for back button
  final VoidCallback? onBackPressed;
  
  /// Additional action buttons to display on the right
  final List<Widget>? actions;
  
  /// Show search icon
  final bool showSearch;
  
  /// Show wishlist/favorites icon
  final bool showFavorites;
  
  /// Show cart icon
  final bool showCart;
  
  /// Show chat icon
  final bool showChat;
  
  /// Callback for search button
  final VoidCallback? onSearchPressed;
  
  /// Callback for favorites button
  final VoidCallback? onFavoritesPressed;
  
  /// Callback for cart button
  final VoidCallback? onCartPressed;
  
  /// Callback for chat button
  final VoidCallback? onChatPressed;

  const AppMainHeader({
    super.key,
    this.dark = false,
    this.title,
    this.showBack = false,
    this.onBackPressed,
    this.actions,
    this.showSearch = false,
    this.showFavorites = false,
    this.showCart = false,
    this.showChat = false,
    this.onSearchPressed,
    this.onFavoritesPressed,
    this.onCartPressed,
    this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeaderBar(
      dark: dark,
      child: Row(
        children: [
          // Menu or Back Button
          AppHeaderIconButton(
            icon: showBack ? Icons.arrow_back_rounded : Icons.menu_rounded,
            onTap: showBack 
                ? (onBackPressed ?? () => navigateBack(context))
                : () => _openDrawer(context),
            backgroundColor: dark 
                ? Colors.white.withOpacity(0.12)
                : const Color(0xFFF0F2F5),
            iconColor: dark ? Colors.white : const Color(0xFF10213B),
          ),
          const SizedBox(width: 10),
          
          // Logo and Title (light theme) or Logo and Brand (dark theme)
          if (dark) ...[
            Image.asset(
              'assets/images/g14_logo.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'G14-TECH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ] else if (title != null) ...[
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10213B),
                ),
              ),
            ),
          ],
          
          const Spacer(),
          
          // Action Buttons
          if (showSearch)
            AppHeaderIconButton(
              icon: Icons.search_rounded,
              onTap: onSearchPressed ?? () {},
              backgroundColor: dark 
                  ? Colors.white.withOpacity(0.12)
                  : const Color(0xFFF0F2F5),
              iconColor: dark ? Colors.white : const Color(0xFF10213B),
            ),
          if (showSearch) const SizedBox(width: 8),
          
          if (showFavorites)
            AppHeaderIconButton(
              icon: Icons.favorite_border_rounded,
              onTap: onFavoritesPressed ?? () => context.go('/wishlist'),
              backgroundColor: dark 
                  ? Colors.white.withOpacity(0.12)
                  : const Color(0xFFF0F2F5),
              iconColor: dark ? Colors.white : const Color(0xFF10213B),
            ),
          if (showFavorites) const SizedBox(width: 8),
          
          if (showCart)
            AppHeaderIconButton(
              icon: Icons.shopping_cart_outlined,
              onTap: onCartPressed ?? () => context.go('/cart'),
              backgroundColor: dark 
                  ? Colors.white.withOpacity(0.12)
                  : const Color(0xFFF0F2F5),
              iconColor: dark ? Colors.white : const Color(0xFF10213B),
            ),
          if (showCart) const SizedBox(width: 8),
          
          if (showChat)
            AppHeaderIconButton(
              icon: Icons.chat_bubble_outline_rounded,
              onTap: onChatPressed ?? () => context.go('/chat'),
              backgroundColor: dark 
                  ? Colors.white.withOpacity(0.12)
                  : const Color(0xFFF0F2F5),
              iconColor: dark ? Colors.white : const Color(0xFF10213B),
            ),
          
          // Custom Actions
          if (actions != null) ...[
            if (showCart || showFavorites || showSearch || showChat)
              const SizedBox(width: 0),
            ...actions!,
          ],
        ],
      ),
    );
  }

  /// Open the app drawer/sidebar
  static void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}
