import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_detail_provider.dart';
import '../widgets/benchmarks_tab.dart';
import '../widgets/config_options_selector.dart';
import '../widgets/media_gallery.dart';
import '../widgets/reviews_tab.dart';
import '../widgets/specs_tab.dart';

class ProductDetailPage extends ConsumerWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed: $err')),
        data: (state) {
          return DefaultTabController(
            length: 3,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                MediaGallery(items: state.media),
                const SizedBox(height: 16),
                Text(
                  state.product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(state.product.shortDescription),
                const SizedBox(height: 12),
                Text(
                  _priceLabel(state),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                ConfigOptionsSelector(
                  options: state.configOptions,
                  selectedOptions: state.selectedOptions,
                  onSelect: (option) {
                    ref
                        .read(productDetailProvider(productId).notifier)
                        .selectOption(option);
                  },
                ),
                const SizedBox(height: 16),
                const TabBar(
                  tabs: [
                    Tab(text: 'Specs'),
                    Tab(text: 'Benchmarks'),
                    Tab(text: 'Reviews'),
                  ],
                ),
                SizedBox(
                  height: 320,
                  child: TabBarView(
                    children: [
                      SpecsTab(specs: state.specs),
                      BenchmarksTab(benchmarks: state.benchmarks),
                      ReviewsTab(reviews: state.reviews),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _priceLabel(ProductDetailState state) {
    final base = state.product.basePrice;
    final deal = state.product.dealPrice;
    final price = deal ?? base;
    return '\$${price.toStringAsFixed(0)}';
  }
}