import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:computer_shop/app/router/product_route.dart';

import '../widgets/compare_section.dart';
import '../widgets/compare_products_strip.dart';
import '../widgets/compare_action_buttons.dart';
import '../providers/compare_provider.dart';
import '../../../shared/header/app_header.dart';
import '../../../shared/footer/app_footer.dart';
import '../../../products/presentation/providers/product_compare_provider.dart';

class ProductComparePage extends ConsumerWidget {
  final List<String> productIds;

  const ProductComparePage({super.key, required this.productIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // use route productIds when provided; otherwise fall back to the global
    // `compareProvider` state so users can toggle items in listing and then
    // open the compare page without passing query params.
    final selectedIds = productIds.isNotEmpty
        ? productIds
        : ref.watch(compareProvider);

    final compareState = ref.watch(
      compareProductProvider(CompareProductsRequest(productIds: selectedIds)),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          AppHeaderBar(
            dark: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(ProductRoutes.products);
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Compare',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(compareProvider.notifier).clear();
                  },
                  child: const Text(
                    'CLEAR ALL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${selectedIds.length} product${selectedIds.length == 1 ? '' : 's'} selected',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Expanded(
            child: selectedIds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No products selected',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.go(ProductRoutes.products),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A66FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'ADD PRODUCTS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : compareState.when(
                    data: (state) {
                      final products = state.products;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              CompareProductsStrip(
                                products: products
                                    .map(
                                      (payload) => CompareProductInfo(
                                        id: payload.product.productId,
                                        title: payload.product.name,
                                        image:
                                            payload
                                                .product
                                                .thumbnailUrl
                                                .isNotEmpty
                                            ? payload.product.thumbnailUrl
                                            : 'assets/images/desktop3.png',
                                        price:
                                            '\$${payload.product.dealPrice ?? payload.product.basePrice}',
                                      ),
                                    )
                                    .toList(),
                                onRemove: (id) {
                                  ref.read(compareProvider.notifier).remove(id);
                                },
                              ),
                              const SizedBox(height: 14),
                              CompareSection(
                                title: 'PERFORMANCE',
                                productNames: products
                                    .map((payload) => payload.product.name)
                                    .toList(),
                                rows: [
                                  CompareRowData(
                                    label: 'Processor',
                                    values: const [
                                      'Core Octa-12 Gen 5',
                                      'Core Hexa-10 Gen',
                                    ],
                                    badges: const [true, false],
                                  ),
                                  CompareRowData(
                                    label: 'Graphics',
                                    values: const [
                                      'Vulkan RTX 4000M',
                                      'Vulkan Core G3',
                                    ],
                                  ),
                                ],
                              ),
                              CompareSection(
                                title: 'MEMORY & STORAGE',
                                productNames: products
                                    .map((payload) => payload.product.name)
                                    .toList(),
                                rows: [
                                  CompareRowData(
                                    label: 'Memory',
                                    values: const [
                                      '32GB DDR5 Unity',
                                      '16GB DDR5 Lite',
                                    ],
                                  ),
                                  CompareRowData(
                                    label: 'Storage',
                                    values: const [
                                      '1TB NVMe Gen 5',
                                      '512GB NVMe Gen 5',
                                    ],
                                  ),
                                ],
                              ),
                              CompareSection(
                                title: 'PHYSICAL',
                                productNames: products
                                    .map((payload) => payload.product.name)
                                    .toList(),
                                rows: [
                                  CompareRowData(
                                    label: 'Weight',
                                    values: const ['1.42 kg', '0.98 kg'],
                                    badges: const [false, true],
                                  ),
                                  CompareRowData(
                                    label: 'Battery Life',
                                    values: const [
                                      'Up to 18 hours',
                                      'Up to 22 hours',
                                    ],
                                    badges: const [false, true],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              CompareActionButtons(
                                productCount: products.length,
                                onAddToCartCallbacks: List.generate(
                                  products.length,
                                  (_) {
                                    return () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Added to cart'),
                                        ),
                                      );
                                    };
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      context.go(ProductRoutes.products),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2A66FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'ADD ANOTHER COMPUTER',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text(
                        'Failed to load compare products',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
          ),
          AppNavigationFooter(currentIndex: 1, onTabSelected: (index) {}),
        ],
      ),
    );
  }
}
