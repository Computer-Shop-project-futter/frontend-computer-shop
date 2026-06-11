import 'package:flutter/material.dart';

import '../../domain/promotion_model.dart';

class PromotionBanner extends StatelessWidget {
  final PromotionModel promotion;
  final VoidCallback? onViewDeals;

  const PromotionBanner({
    super.key,
    required this.promotion,
    this.onViewDeals,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF101826),
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: NetworkImage(promotion.bannerUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.55),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PROMOTION',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              promotion.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${promotion.startDate} - ${promotion.endDate}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onViewDeals,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A66FF),
                foregroundColor: Colors.white,
              ),
              child: const Text('View Deals'),
            ),
          ],
        ),
      ),
    );
  }
}
