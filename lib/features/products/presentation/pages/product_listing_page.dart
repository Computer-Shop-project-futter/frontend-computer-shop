import 'package:computer_shop/features/products/domain/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/products_provider.dart';
import '../../../compare/presentation/providers/compare_provider.dart';
import '../../../shared/footer/app_footer.dart';
import '../../../shared/header/app_header.dart';
import 'package:computer_shop/features/cart/presentation/providers/checkout_provider.dart';
import 'package:computer_shop/features/cart/domain/checkout_model.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_page_chrome.dart';

class ProductListingPage extends ConsumerWidget {
  const ProductListingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);
    final compareIds = ref.watch(compareProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          AppHeaderBar(
            dark: true,
            child: Row(
              children: [
                AppHeaderIconButton(
                  icon: Icons.menu_rounded,
                  onTap: () => _openFilters(context, ref),
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 10),
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
                const Spacer(),
                AppHeaderIconButton(
                  icon: Icons.search_rounded,
                  onTap: () => _openFilters(context, ref),
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 8),
                AppHeaderIconButton(
                  icon: Icons.favorite_border_rounded,
                  onTap: () {},
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 8),
                AppHeaderIconButton(
                  icon: Icons.shopping_cart_outlined,
                  onTap: () => context.go('/products'),
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: productsState.when(
              loading: () =>
                  _LoadingList(onFilterTap: () => _openFilters(context, ref)),
              error: (err, _) => Center(child: Text('Failed: $err')),
              data: (state) {
                final gridItems = state.items;
                final componentItems = state.items.length > 2
                    ? state.items.sublist(2)
                    : state.items;

                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 120) {
                      ref.read(productsProvider.notifier).loadMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(productsProvider.notifier).resetFilters();
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: ProductHeroBanner(
                            onBrowseTap: () => _openFilters(context, ref),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _SearchAndFilters(
                            onFilterTap: () => _openFilters(context, ref),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _ResultRow(
                            count: state.items.length,
                            onSortTap: () {},
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: _SectionTitle(title: 'SYSTEMS'),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.78,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= gridItems.length) {
                                  return const _ProductCardPlaceholder();
                                }
                                final product = gridItems[index];
                                return _ProductGridCard(
                                  name: product.name,
                                  price: product.dealPrice ?? product.basePrice,
                                  imageUrl: product.thumbnailUrl,
                                  imageFallbackAsset:
                                      _catalogAssets[index %
                                          _catalogAssets.length],
                                  onTap: () => context.go(
                                    '/products/${product.productId}',
                                  ), product: product,
                                );
                              },
                              childCount: gridItems.isEmpty
                                  ? 4
                                  : gridItems.length,
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: _SectionTitle(title: 'PC COMPONENTS'),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= componentItems.length) {
                                  return const _ComponentRowPlaceholder();
                                }
                                final product = componentItems[index];
                                return _ComponentRow(
                                  name: product.name,
                                  subtitle: product.shortDescription,
                                  price: product.dealPrice ?? product.basePrice,
                                  imageUrl: product.thumbnailUrl,
                                  imageFallbackAsset:
                                      'assets/images/g14_logo.png',
                                  onTap: () => context.go(
                                    '/products/${product.productId}',
                                  ),
                                );
                              },
                              childCount: componentItems.isEmpty
                                  ? 3
                                  : componentItems.length,
                            ),
                          ),
                        ),
                        if (state.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (compareIds.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${compareIds.length} product${compareIds.length == 1 ? '' : 's'} selected to compare',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/product/compare'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('View Compare'),
                  ),
                ],
              ),
            ),
          AppNavigationFooter(
            currentIndex: 1,
            onTabSelected: (index) {
              if (index == 0) {
                context.go('/');
              } else if (index == 1) {
                context.go('/products');
              }
            },
          ),
        ],
      ),
    );
  }

  void _openFilters(BuildContext context, WidgetRef ref) {
    final current = ref.read(productsProvider).value;
    if (current == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterBottomSheet(
          initialFilters: current.filters,
          onApply: (filters) {
            ref.read(productsProvider.notifier).applyFilter(filters);
            Navigator.of(context).pop();
          },
          onReset: () {
            ref.read(productsProvider.notifier).resetFilters();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters({required this.onFilterTap});

  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 18),
              hintText: 'Search products...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              _FilterChip(label: 'LAPTOPS', onTap: onFilterTap),
              _FilterChip(label: 'UNDER \$1000', onTap: onFilterTap),
              _FilterChip(label: 'NVIDIA', onTap: onFilterTap),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFCAD8F7)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF2A66FF),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF12306A),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.close, size: 12, color: Color(0xFF2A66FF)),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.count, required this.onSortTap});

  final int count;
  final VoidCallback? onSortTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Text(
            '$count RESULTS',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFF6B7280),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSortTap,
            child: Row(
              children: const [
                Text(
                  'SORT: FEATURED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A66FF),
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Color(0xFF2A66FF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ProductGridCard extends ConsumerWidget {
  const _ProductGridCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.imageFallbackAsset,
    required this.product,
    required this.onTap,

  });

  final String name;
  final double price;
  final String imageUrl;
  final String imageFallbackAsset;
  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareIds = ref.watch(compareProvider);

    final isSelected = compareIds.contains(product.productId);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _CatalogImage(
                      imageUrl: imageUrl,
                      fallbackAsset: imageFallbackAsset,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(compareProvider.notifier).toggle(product.productId);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2A66FF) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(
                          Icons.compare_arrows,
                          size: 16,
                          color: isSelected ? Colors.white : Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A66FF),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final price = product.dealPrice ?? product.basePrice;
                    ref.read(checkoutProvider.notifier).addItem(OrderItem(
                      id: product.productId,
                      name: product.name,
                      type: 'PRODUCT',
                      variant: '',
                      quantity: 1,
                      price: price,
                      imageUrl: product.thumbnailUrl,
                    ));
                    context.go('/checkout');
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A66FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.imageFallbackAsset,
    required this.onTap,
  });

  final String name;
  final String subtitle;
  final double price;
  final String imageUrl;
  final String imageFallbackAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _CatalogImage(
                imageUrl: imageUrl,
                fallbackAsset: imageFallbackAsset,
                width: 52,
                height: 52,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  '\$${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A66FF),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A66FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 14, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCardPlaceholder extends StatelessWidget {
  const _ProductCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 10, color: Colors.grey.shade200),
          const SizedBox(height: 6),
          Container(width: 80, height: 10, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class _ComponentRowPlaceholder extends StatelessWidget {
  const _ComponentRowPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, color: Colors.grey.shade200),
                const SizedBox(height: 6),
                Container(width: 120, height: 10, color: Colors.grey.shade200),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 36, height: 10, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList({required this.onFilterTap});

  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: ProductHeroBanner(onBrowseTap: _noop)),
        SliverToBoxAdapter(child: _SearchAndFilters(onFilterTap: onFilterTap)),
        const SliverToBoxAdapter(child: _ResultRow(count: 0, onSortTap: null)),
        const SliverToBoxAdapter(child: _SectionTitle(title: 'SYSTEMS')),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const _ProductCardPlaceholder(),
              childCount: 4,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _SectionTitle(title: 'PC COMPONENTS')),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const _ComponentRowPlaceholder(),
              childCount: 3,
            ),
          ),
        ),
      ],
    );
  }
}

const List<String> _catalogAssets = [
  'assets/images/desktop3.png',
  'assets/images/destop2.png',
  'assets/images/board.png',
];

void _noop() {}

class _CatalogImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackAsset;
  final double? width;
  final double? height;

  const _CatalogImage({
    required this.imageUrl,
    required this.fallbackAsset,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();

    if (url.isNotEmpty) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          fallbackAsset,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      fallbackAsset,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
