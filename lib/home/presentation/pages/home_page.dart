import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/home_provider.dart';
import '../widgets/deals_section.dart';
import '../widgets/featured_rigs_section.dart';
import '../widgets/hero_banner.dart';
import '../widgets/promotion_banner.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: homeState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Failed: $err')),
          data: (state) {
            final promotion =
                state.promotions.isNotEmpty ? state.promotions.first : null;
            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const SizedBox(height: 12),
                HeroBanner(
                  onShopNow: () => context.go('/products'),
                  onBuildPc: () => context.go('/products'),
                ),
                const SizedBox(height: 18),
                FeaturedRigsSection(
                  products: state.featuredProducts,
                  onProductTap: (product) {
                    context.go('/products/${product.productId}');
                  },
                ),
                const SizedBox(height: 18),
                DealsSection(
                  deals: state.deals,
                  onDealTap: (deal) {
                    context.go('/products/${deal.productId}');
                  },
                ),
                const SizedBox(height: 18),
                if (promotion != null)
                  PromotionBanner(
                    promotion: promotion,
                    onViewDeals: () => context.go('/products'),
                  ),
                const SizedBox(height: 18),
                _pcBuilderCta(context),
                const SizedBox(height: 18),
                _communityShowcase(context),
                const SizedBox(height: 18),
                _footer(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _pcBuilderCta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Build Your Dream PC',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Customize parts, balance performance, and order fast.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => context.go('/products'),
              child: const Text('Start Build'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _communityShowcase(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMMUNITY SHOWCASE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600',
                    width: 220,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'G14-TECH 2026. Built for your next legend.',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
    );
  }
}
