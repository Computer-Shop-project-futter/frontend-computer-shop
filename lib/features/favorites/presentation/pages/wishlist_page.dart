// lib/features/favorites/presentation/pages/wishlist_page.dart

import 'package:computer_shop/features/favorites/presentation/widgets/wishlist_category_chips.dar';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/wishlist_provider.dart';
import '../widgets/wishlist_item_card.dart';
import '../widgets/wishlist_search_bar.dart';
import '../../../shared/header/app_header.dart'; // Add this import
import '../../../shared/footer/app_footer.dart'; // Add this import


class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistProvider);
    final filteredItems = wishlistState.filteredItems;
    final productCount = wishlistState.productCount;
    final buildCount = wishlistState.buildCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          // Use AppHeaderBar with dark mode
          AppHeaderBar(
            dark: true,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                // Back button
                AppHeaderIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(),
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 10),
                
                // Logo
                Image.asset(
                  'assets/images/g14_logo.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                
                // Brand name
                const Text(
                  'G14-TECH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),
                
                // Search button
                AppHeaderIconButton(
                  icon: Icons.search_rounded,
                  onTap: () {},
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 8),
                
                // Cart button
                AppHeaderIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onTap: () => context.go('/cart'),
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: wishlistState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Header Section with Count
                      _WishlistHeader(
                        itemCount: filteredItems.length,
                        productCount: productCount,
                        buildCount: buildCount,
                        onClearAll: () {
                          _showClearAllDialog(context, ref);
                        },
                      ),

                      // Search Bar
                      WishlistSearchBar(
                        initialQuery: wishlistState.searchQuery,
                        onSearch: (query) {
                          ref.read(wishlistProvider.notifier).setSearchQuery(query);
                        },
                      ),

                      // Category Filters
                      WishlistCategoryChips(
                        selectedFilters: wishlistState.selectedCategoryFilters,
                        productCount: productCount,
                        buildCount: buildCount,
                        onFilterTap: (category) {
                          ref.read(wishlistProvider.notifier).toggleCategoryFilter(category);
                        },
                      ),

                      const SizedBox(height: 8),

                      // Items List
                      Expanded(
                        child: filteredItems.isEmpty
                            ? _EmptyWishlist(
                                hasFilters: wishlistState.searchQuery != null ||
                                    wishlistState.selectedCategoryFilters.isNotEmpty,
                                onClearFilters: () {
                                  ref.read(wishlistProvider.notifier).clearFilters();
                                },
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: filteredItems.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = filteredItems[index];
                                  return WishlistItemCard(
                                    item: item,
                                    onAddToCart: () async {
                                      await ref.read(wishlistProvider.notifier).addToCart(item);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${item.name} added to cart'),
                                            backgroundColor: const Color(0xFF2A66FF),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    onRemove: () async {
                                      await ref.read(wishlistProvider.notifier).removeItem(item.id);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Removed from wishlist'),
                                            backgroundColor: Color(0xFFEF4444),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),

          // Use AppNavigationFooter
          AppNavigationFooter(
            currentIndex: 2,
            onTabSelected: (index) {},
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Wishlist?'),
        content: const Text('This will remove all items from your wishlist. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(wishlistProvider.notifier).clearAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wishlist cleared'),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _WishlistHeader extends StatelessWidget {
  final int itemCount;
  final int productCount;
  final int buildCount;
  final VoidCallback onClearAll;

  const _WishlistHeader({
    required this.itemCount,
    required this.productCount,
    required this.buildCount,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wishlist',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10213B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemCount item${itemCount == 1 ? '' : 's'} saved',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7891),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.inventory_2_outlined,
                      label: 'Products',
                      count: productCount,
                    ),
                    const SizedBox(width: 10),
                    _StatChip(
                      icon: Icons.build_outlined,
                      label: 'Builds',
                      count: buildCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (itemCount > 0)
            TextButton.icon(
              onPressed: onClearAll,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear All'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E9F5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2A66FF)),
          const SizedBox(width: 6),
          Text(
            '$label ($count)',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10213B),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;

  const _EmptyWishlist({
    required this.hasFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasFilters ? Icons.search_off_rounded : Icons.favorite_border_rounded,
              size: 50,
              color: const Color(0xFF2A66FF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasFilters ? 'No matching items' : 'Your wishlist is empty',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF10213B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try adjusting your search or filters'
                : 'Save your favorite products and builds here',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7891),
            ),
          ),
          const SizedBox(height: 24),
          if (hasFilters)
            ElevatedButton(
              onPressed: onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A66FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Clear Filters'),
            ),
        ],
      ),
    );
  }
}
