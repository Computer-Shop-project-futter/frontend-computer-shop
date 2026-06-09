import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:computer_shop/features/compare/presentation/providers/compare_provider.dart';

import '../../domain/product_benchmark_model.dart';
import '../../domain/product_config_option_model.dart';
import '../../domain/product_model.dart';
import '../../domain/product_spec_model.dart';
import '../../data/products_repository.dart';
import '../providers/products_provider.dart';
import '../../../shared/footer/app_footer.dart';
import '../../../shared/header/app_header.dart';
import 'package:computer_shop/features/cart/domain/checkout_model.dart';
import 'package:computer_shop/features/cart/presentation/providers/checkout_provider.dart';
import '../widgets/benchmarks_tab.dart';
import '../widgets/media_gallery.dart';
import '../widgets/reviews_tab.dart';
import '../widgets/specs_tab.dart';

final productDetailProvider =
    FutureProvider.family<ProductDetailPayload, String>((ref, productId) async {
      final repository = ref.read(productsRepositoryProvider);
      return repository.getProductById(productId);
    });

final productDetailSelectionProvider =
    StateNotifierProvider.family<
      ProductDetailSelectionNotifier,
      Map<String, ProductConfigOptionModel>,
      String
    >((ref, productId) => ProductDetailSelectionNotifier());

class ProductDetailState {
  final ProductDetailPayload payload;
  final Map<String, ProductConfigOptionModel> selectedOptions;

  const ProductDetailState({
    required this.payload,
    required this.selectedOptions,
  });

  ProductModel get product => payload.product;
  List<ProductSpecModel> get specs => payload.specs;
  List<ProductBenchmarkModel> get benchmarks => payload.benchmarks;
  List<ProductConfigOptionModel> get configOptions => payload.configOptions;
  List<ProductMediaItem> get media => payload.media;
  List<ReviewModel> get reviews => payload.reviews;

  ProductDetailState copyWith({
    ProductDetailPayload? payload,
    Map<String, ProductConfigOptionModel>? selectedOptions,
  }) {
    return ProductDetailState(
      payload: payload ?? this.payload,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  factory ProductDetailState.fromPayload(ProductDetailPayload payload) {
    final selectedOptions = <String, ProductConfigOptionModel>{};
    for (final option in payload.configOptions) {
      if (option.isDefault &&
          !selectedOptions.containsKey(option.optionGroup)) {
        selectedOptions[option.optionGroup] = option;
      }
    }

    return ProductDetailState(
      payload: payload,
      selectedOptions: selectedOptions,
    );
  }
}

class ProductDetailSelectionNotifier
    extends StateNotifier<Map<String, ProductConfigOptionModel>> {
  ProductDetailSelectionNotifier() : super(const {});

  void selectOption(ProductConfigOptionModel option) {
    state = {...state, option.optionGroup: option};
  }
}

class ProductDetailPage extends ConsumerWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(productDetailProvider(productId));
    final selectedCompareIds = ref.watch(compareProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          AppHeaderBar(
            dark: true,
            child: Row(
              children: [
                AppHeaderIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),
                AppHeaderIconButton(
                  icon: Icons.favorite_border_rounded,
                  onTap: () {},
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 8),
                AppHeaderIconButton(
                  icon: Icons.share_outlined,
                  onTap: () {},
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
          if (selectedCompareIds.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMPARE PRODUCTS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6B7891),
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedCompareIds.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final id = selectedCompareIds[index];
                        final isSelected = id == productId;
                        return GestureDetector(
                           onTap: () {
                             context.pushReplacement('/products/$id');
                           },
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2A66FF)
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? const Color(0xFFEAF1FF)
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'PC ${index + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? const Color(0xFF2A66FF)
                                      : const Color(0xFF6B7891),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: detailState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Failed: $err')),
              data: (payload) {
                final selectedOptions = ref.watch(
                  productDetailSelectionProvider(productId),
                );
                final defaultOptions = {
                  for (final option in payload.configOptions)
                    if (option.isDefault) option.optionGroup: option,
                };
                final state = ProductDetailState(
                  payload: payload,
                  selectedOptions: {...defaultOptions, ...selectedOptions},
                );
                return DefaultTabController(
                  length: 3,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      _DetailHeroCard(
                        state: state,
                        onSelectOption: (option) {
                          ref
                              .read(
                                productDetailSelectionProvider(
                                  productId,
                                ).notifier,
                              )
                              .selectOption(option);
                        },
                        onAddToCart: () {
                          final notifier = ref.read(checkoutProvider.notifier);
                          final product = payload.product;
                          final price = product.dealPrice ?? product.basePrice;
                          notifier.addItem(OrderItem(
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
                        onAddToWishlist: () {},
                        onCompare: () {
                          // toggle current product into compare list then open compare
                          ref.read(compareProvider.notifier).toggle(productId);
                          context.go('/product/compare');
                        },
                      ),
                      const SizedBox(height: 14),
                      _SectionHeader(
                        title: 'PERFORMANCE',
                        subtitle: 'Quick snapshot of the build',
                      ),
                      const SizedBox(height: 10),
                      _PerformanceCard(benchmarks: state.benchmarks),
                      const SizedBox(height: 14),
                      _SectionHeader(
                        title: 'SPECIFICATIONS',
                        subtitle: 'Hardware details',
                      ),
                      const SizedBox(height: 10),
                      _SpecsCard(specs: state.specs),
                      const SizedBox(height: 14),
                      _SectionHeader(
                        title: 'REVIEWS',
                        subtitle: '${state.reviews.length} customer reviews',
                      ),
                      const SizedBox(height: 10),
                      _ReviewsPreview(reviews: state.reviews),
                      const SizedBox(height: 14),
                      _SectionHeader(
                        title: 'COMPLETE YOUR SETUP',
                        subtitle: 'Recommended accessories',
                      ),
                      const SizedBox(height: 10),
                      _SetupSuggestions(
                        onProductTap: (productId) {
                          context.push('/products/$productId');
                        },
                      ),
                    ],
                  ),
                );
              },
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
}

class _DetailHeroCard extends StatelessWidget {
  final ProductDetailState state;
  final ValueChanged<ProductConfigOptionModel> onSelectOption;
  final VoidCallback onAddToCart;
  final VoidCallback onAddToWishlist;
  final VoidCallback onCompare;

  const _DetailHeroCard({
    required this.state,
    required this.onSelectOption,
    required this.onAddToCart,
    required this.onAddToWishlist,
    required this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    final price = state.product.dealPrice ?? state.product.basePrice;
    final originalPrice = state.product.dealPrice != null
        ? state.product.basePrice
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaGallery(items: state.media),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BEST SELLER',
                    style: TextStyle(
                      color: Color(0xFF2A66FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.product.name,
                    style: const TextStyle(
                      color: Color(0xFF10213B),
                      fontSize: 22,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.product.shortDescription,
                    style: const TextStyle(
                      color: Color(0xFF6B7891),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFF2A66FF),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (originalPrice != null) ...[
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '\$${originalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color(0xFF98A2B3),
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      _BadgeChip(label: 'By ITOCK'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SELECT RAM',
                    style: TextStyle(
                      color: Color(0xFF6B7891),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.configOptions
                        .where(
                          (option) =>
                              option.optionGroup.toLowerCase().contains('ram'),
                        )
                        .map(
                          (option) => _OptionChip(
                            label: option.optionLabel,
                            selected:
                                state.selectedOptions[option.optionGroup] ==
                                option,
                            onTap: () => onSelectOption(option),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'STORAGE',
                    style: TextStyle(
                      color: Color(0xFF6B7891),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.configOptions
                        .where(
                          (option) => option.optionGroup.toLowerCase().contains(
                            'storage',
                          ),
                        )
                        .map(
                          (option) => _OptionChip(
                            label: option.optionLabel,
                            selected:
                                state.selectedOptions[option.optionGroup] ==
                                option,
                            onTap: () => onSelectOption(option),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onAddToCart,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2A66FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'ADD TO CART',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onAddToWishlist,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2A66FF),
                        side: const BorderSide(color: Color(0xFFBFD0FA)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'ADD TO WISHLIST',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: onCompare,
                      child: const Text(
                        'COMPARE',
                        style: TextStyle(
                          color: Color(0xFF2A66FF),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TabBar(
                    labelColor: Color(0xFF2A66FF),
                    unselectedLabelColor: Color(0xFF7A8090),
                    tabs: [
                      Tab(text: 'Specs'),
                      Tab(text: 'Benchmarks'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                  SizedBox(
                    height: 250,
                    child: TabBarView(
                      children: [
                        SpecsTab(specs: state.specs),
                        BenchmarksTab(benchmarks: state.benchmarks),
                        ReviewsTab(reviews: state.reviews),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF10213B),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6B7891),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final List<ProductBenchmarkModel> benchmarks;

  const _PerformanceCard({required this.benchmarks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E9F5)),
      ),
      child: Column(
        children: benchmarks.take(2).map((benchmark) {
          final score = benchmark.barPercent.clamp(0, 1).toDouble();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        benchmark.metricKey,
                        style: const TextStyle(
                          color: Color(0xFF10213B),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      benchmark.metricValue,
                      style: const TextStyle(
                        color: Color(0xFF2A66FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: score,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFEAF1FF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF2A66FF),
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SpecsCard extends StatelessWidget {
  final List<ProductSpecModel> specs;

  const _SpecsCard({required this.specs});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E9F5)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < specs.length; index++) ...[
            _SpecRow(
              label: specs[index].specKey,
              value: specs[index].specValue,
            ),
            if (index != specs.length - 1)
              const Divider(height: 1, thickness: 1, indent: 14, endIndent: 14),
          ],
        ],
      ),
    );
  }
}

class _ReviewsPreview extends StatelessWidget {
  final List<ReviewModel> reviews;

  const _ReviewsPreview({required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const _EmptyCard(text: 'No reviews yet');
    }

    final review = reviews.first;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E9F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFEAF1FF),
                child: Icon(Icons.person, color: Color(0xFF2A66FF), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  review.author,
                  style: const TextStyle(
                    color: Color(0xFF10213B),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF4B400),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                review.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Color(0xFF10213B),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.body,
            style: const TextStyle(
              color: Color(0xFF4D5A72),
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupSuggestions extends StatelessWidget {
  final ValueChanged<String> onProductTap;

  const _SetupSuggestions({required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final items = [
            _SuggestionItem(
              productId: '3',
              title: 'Monitor Ultra 32", 4K',
              asset: 'assets/images/desktop3.png',
            ),
            _SuggestionItem(
              productId: '4',
              title: 'Keyboard Pro RGB',
              asset: 'assets/images/board.png',
            ),
          ];
          final item = items[index];
          return InkWell(
            onTap: () => onProductTap(item.productId),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE3E9F5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(item.asset, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF10213B),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: 2,
      ),
    );
  }
}

class _SuggestionItem {
  final String productId;
  final String title;
  final String asset;

  const _SuggestionItem({
    required this.productId,
    required this.title,
    required this.asset,
  });
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7891),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF10213B),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;

  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2A66FF),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF2A66FF),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF10213B),
        fontWeight: FontWeight.w700,
        fontSize: 11,
      ),
      side: const BorderSide(color: Color(0xFFD7E4FF)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String text;

  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E9F5)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF6B7891), fontSize: 12),
      ),
    );
  }
}
