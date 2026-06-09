import 'package:computer_shop/features/shared/footer/app_footer.dart';
import 'package:computer_shop/features/shared/header/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:computer_shop/features/compare/presentation/providers/compare_provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/home_provider.dart';
import '../widgets/featured_rigs_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FB),
      body: SafeArea(
        child: homeState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text(
              'Failed: $err',
              style: const TextStyle(color: Color(0xFF10213B)),
            ),
          ),
          data: (state) {
            final featuredProduct = state.featuredProducts.isNotEmpty
                ? state.featuredProducts.first
                : null;
            final featuredDeal = state.deals.isNotEmpty
                ? state.deals.first
                : null;
            final promotion = state.promotions.isNotEmpty
                ? state.promotions.first
                : null;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                AppHeaderBar(
                  dark: true,
                  child: Row(
                    children: [
                      AppHeaderIconButton(
                        icon: Icons.menu_rounded,
                        onTap: () => context.go('/products'),
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
                        onTap: () => context.go('/products'),
                        backgroundColor: Colors.white.withOpacity(0.12),
                        iconColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      AppHeaderIconButton(
                        icon: Icons.storefront_rounded,
                        onTap: () => context.go('/products'),
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
                const SizedBox(height: 16),
                _HeroFeatureCard(
                  product: featuredProduct,
                  promotion: promotion,
                  onExploreTap: () {
                    if (featuredProduct != null) {
                      context.go('/products/${featuredProduct.productId}');
                    } else {
                      context.go('/products');
                    }
                  },
                  onCompareTap: () {
                    if (featuredProduct != null) {
                      ref.read(compareProvider.notifier).toggle(featuredProduct.productId);
                      context.go('/product/compare');
                    } else {
                      context.go('/products');
                    }
                  },
                ),
                const SizedBox(height: 14),
                FeaturedRigsSection(
                  products: state.featuredProducts,
                  onProductTap: (product) => context.go('/products/${product.productId}'),
                ),
                const SizedBox(height: 14),
                _QuickPillRow(
                  onFirstTap: () => context.go('/products'),
                  onSecondTap: () => context.go('/products'),
                  onThirdTap: () => context.go('/products'),
                ),
                const SizedBox(height: 14),
                _CompactActionRow(
                  onPrimaryTap: () => context.go('/products'),
                  onSecondaryTap: () => context.go('/products'),
                ),
                const SizedBox(height: 14),
                _SectionTitle(
                  title: 'OVERVIEW',
                  actionText: 'DETAILS',
                  onActionTap: () => context.go('/products'),
                ),
                const SizedBox(height: 10),
                _SpecCard(
                  specs: [
                    MapEntry(
                      'Featured',
                      featuredProduct?.name ?? 'Latest catalog build',
                    ),
                    MapEntry(
                      'Base price',
                      featuredProduct != null
                          ? '\$${featuredProduct.basePrice.toStringAsFixed(0)}'
                          : 'Loading',
                    ),
                    MapEntry(
                      'Deal price',
                      featuredDeal?.dealPrice != null
                          ? '\$${featuredDeal!.dealPrice!.toStringAsFixed(0)}'
                          : 'No active deal',
                    ),
                    MapEntry(
                      'Promotion',
                      promotion?.title ?? 'Today\'s highlights',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _RatingCard(onTap: () => context.go('/products')),
                const SizedBox(height: 14),
                _ReviewCard(
                  title: featuredProduct?.name ?? 'Apex-Ultimate Gaming Rig',
                  subtitle:
                      featuredDeal?.shortDescription ??
                      'Optimized for gaming, creation, and heavy multitasking.',
                ),
                const SizedBox(height: 18),
                _SectionTitle(
                  title: 'LATEST DEALS',
                  actionText: 'VIEW ALL',
                  onActionTap: () => context.go('/products'),
                ),
                const SizedBox(height: 10),
                _DealsRail(
                  featuredProduct: featuredProduct,
                  dealProduct: featuredDeal,
                  onProductTap: (productId) {
                    context.go('/products/$productId');
                  },
                ),
                const SizedBox(height: 18),
                _PromoStrip(
                  promotion: promotion,
                  onTap: () => context.go('/products'),
                ),
                const SizedBox(height: 18),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AppNavigationFooter(
        currentIndex: 0,
        onTabSelected: (index) {
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/products');
          }
        },
      ),
    );
  }
}

class _HeroFeatureCard extends StatelessWidget {
  final Object? product;
  final Object? promotion;
  final VoidCallback onExploreTap;
  final VoidCallback onCompareTap;

  const _HeroFeatureCard({
    required this.product,
    required this.promotion,
    required this.onExploreTap,
    required this.onCompareTap,
  });

  @override
  Widget build(BuildContext context) {
    final heroTitle = _stringValue(product, 'name')?.isNotEmpty == true
        ? _stringValue(product, 'name')!
        : 'Apex-Ultimate Gaming Rig';
    final heroSubtitle =
        _stringValue(promotion, 'description')?.isNotEmpty == true
        ? _stringValue(promotion, 'description')!
        : 'High-end performance tuned for 4K gaming, editing, and streaming.';
    final heroPrice = _numValue(product, 'basePrice') ?? 2899;
    

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF12306A), Color(0xFF0D1C3E)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12306A).withOpacity(0.24),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroVideoPanel(
            title: heroTitle,
            subtitle: heroSubtitle,
            price: heroPrice.toDouble(),
            videoAssetPath: 'assets/videos/hero.mp4',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PrimaryButton(
                  label: 'EXPLORE TO CART',
                  onTap: onExploreTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SecondaryButton(label: 'COMPARE', onTap: onCompareTap),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InlineInfoCard(
                  title: 'FAST BUILD',
                  subtitle: 'Ships in 48h',
                  icon: Icons.local_shipping_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InlineInfoCard(
                  title: 'WARRANTY',
                  subtitle: '2 years support',
                  icon: Icons.verified_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroVideoPanel extends StatefulWidget {
  final String title;
  final String subtitle;
  final double price;
  final String videoAssetPath;

  const _HeroVideoPanel({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.videoAssetPath,
  });

  @override
  State<_HeroVideoPanel> createState() => _HeroVideoPanelState();
}

class _HeroVideoPanelState extends State<_HeroVideoPanel> {
  late final VideoPlayerController _controller;
  late final Future<void> _initialized;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAssetPath)
      ..setLooping(true)
      ..setVolume(0);
    _initialized = _controller.initialize().then((_) {
      if (mounted) {
        _controller.play();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF12306A), Color(0xFF0D1C3E)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF12306A).withOpacity(0.24),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder<void>(
                future: _initialized,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      !_controller.value.isInitialized) {
                    return const _HeroFallbackArt();
                  }

                  return FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0B1A37).withOpacity(0.24),
                      const Color(0xFF0B1A37).withOpacity(0.82),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/g14_logo.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'G14 TECH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FEATURED BUILD',
                      style: TextStyle(
                        color: Color(0xFF8FB4FF),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _StatChip(
                          label: 'STARTS AT',
                          value: '\$${widget.price.toStringAsFixed(0)}',
                        ),
                        const SizedBox(width: 10),
                        const _StatChip(label: 'RATING', value: '4.8'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroFallbackArt extends StatelessWidget {
  const _HeroFallbackArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A3470), Color(0xFF0B1530)],
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/g14_logo.png',
          width: 96,
          height: 96,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _QuickPillRow extends StatelessWidget {
  final VoidCallback onFirstTap;
  final VoidCallback onSecondTap;
  final VoidCallback onThirdTap;

  const _QuickPillRow({
    required this.onFirstTap,
    required this.onSecondTap,
    required this.onThirdTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PillTile(
            icon: Icons.memory_rounded,
            label: 'RAM',
            onTap: onFirstTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PillTile(
            icon: Icons.developer_board_rounded,
            label: 'GPU',
            onTap: onSecondTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PillTile(
            icon: Icons.storage_rounded,
            label: 'SSD',
            onTap: onThirdTap,
          ),
        ),
      ],
    );
  }
}

class _CompactActionRow extends StatelessWidget {
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  const _CompactActionRow({
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            title: 'BUILD PC',
            subtitle: 'Customize your rig',
            accentColor: const Color(0xFF2D73FF),
            onTap: onPrimaryTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionCard(
            title: 'SUPPORT',
            subtitle: 'Talk to experts',
            accentColor: const Color(0xFF0E1E3E),
            onTap: onSecondaryTap,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  const _SectionTitle({
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Color(0xFF10213B),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF2D73FF),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecCard extends StatelessWidget {
  final List<MapEntry<String, String>> specs;

  const _SpecCard({required this.specs});

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
            _SpecRow(label: specs[index].key, value: specs[index].value),
            if (index != specs.length - 1)
              const Divider(height: 1, thickness: 1, indent: 14, endIndent: 14),
          ],
        ],
      ),
    );
  }
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

class _RatingCard extends StatelessWidget {
  final VoidCallback onTap;

  const _RatingCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Color(0xFF2D73FF),
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF10213B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Trusted by creators and gamers',
                    style: TextStyle(
                      color: Color(0xFF6B7891),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFB3BDD1)),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ReviewCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
                child: Icon(Icons.person, color: Color(0xFF2D73FF), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF10213B),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Verified buyer review',
                      style: TextStyle(
                        color: Color(0xFF6B7891),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 18),
                  SizedBox(width: 2),
                  Text(
                    '4.8',
                    style: TextStyle(
                      color: Color(0xFF10213B),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF4D5A72),
              height: 1.45,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DealsRail extends StatelessWidget {
  final Object? featuredProduct;
  final Object? dealProduct;
  final ValueChanged<String> onProductTap;

  const _DealsRail({
    required this.featuredProduct,
    required this.dealProduct,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = <Object?>[
      if (featuredProduct != null) featuredProduct,
      if (dealProduct != null) dealProduct,
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = items[index];
          final price =
              _numValue(product, 'dealPrice') ??
              _numValue(product, 'basePrice') ??
              0;
          return InkWell(
            onTap: () => onProductTap(_stringValue(product, 'productId') ?? ''),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 170,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ProductVisual(
                      imageUrl: _stringValue(product, 'thumbnailUrl') ?? '',
                      fallbackImageUrl:
                          'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=900&q=80',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _stringValue(product, 'name') ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF10213B),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${price.toDouble().toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF2D73FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PromoStrip extends StatelessWidget {
  final Object? promotion;
  final VoidCallback onTap;

  const _PromoStrip({required this.promotion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = _stringValue(promotion, 'title')?.isNotEmpty == true
        ? _stringValue(promotion, 'title')!
        : 'Weekend Power Deals';
    final subtitle = _stringValue(promotion, 'description')?.isNotEmpty == true
        ? _stringValue(promotion, 'description')!
        : 'Limited time offers on gaming rigs, monitors, and accessories.';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEAF1FF), Color(0xFFF7FAFF)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFD9E4FF)),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.local_offer_rounded,
                color: Color(0xFF2D73FF),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PROMOTION',
                    style: TextStyle(
                      color: Color(0xFF6B7891),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF10213B),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF4D5A72),
                      fontSize: 12,
                      height: 1.4,
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

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D73FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEAF1FF),
          side: const BorderSide(color: Color(0xFF789AF0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        ),
      ),
    );
  }
}

class _InlineInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _InlineInfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PillTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3E9F5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2D73FF), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
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
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3E9F5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: accentColor,
                size: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF10213B),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF6B7891),
                fontSize: 11,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductVisual extends StatelessWidget {
  final String imageUrl;
  final String fallbackImageUrl;

  const _ProductVisual({
    required this.imageUrl,
    required this.fallbackImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A3470), Color(0xFF0B1530)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              url.isNotEmpty ? url : fallbackImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _ProductPlaceholder(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.22)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductPlaceholder extends StatelessWidget {
  const _ProductPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF223D7A), Color(0xFF0C1734)],
        ),
      ),
      child: Center(
        child: Container(
          width: 56,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: const Icon(
            Icons.desktop_windows_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

String? _stringValue(Object? object, String key) {
  if (object == null) {
    return null;
  }

  try {
    final value = (object as dynamic).toJson()[key];
    return value?.toString();
  } catch (_) {
    try {
      return (object as dynamic)
          .toJson()
          .cast<String, dynamic>()[key]
          ?.toString();
    } catch (_) {
      return null;
    }
  }
}

num? _numValue(Object? object, String key) {
  if (object == null) {
    return null;
  }

  try {
    final value = (object as dynamic).toJson()[key];
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '');
  } catch (_) {
    return null;
  }
}
