import 'package:flutter/material.dart';

import '../../data/products_repository.dart';

class ReviewsTab extends StatelessWidget {
  final List<ReviewModel> reviews;

  const ReviewsTab({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(
        child: Text(
          'No reviews yet.',
          style: TextStyle(
            color: Color(0xFF6B7891),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final average = reviews
            .map((review) => review.rating)
            .fold<double>(0, (sum, value) => sum + value) /
        reviews.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10306A), Color(0xFF2A66FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Average rating ${average.toStringAsFixed(1)} / 5',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...reviews.map(
          (review) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE3E9F5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF1FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF2A66FF),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10213B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            review.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6B7891),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF10213B),
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
          ),
        ),
      ],
    );
  }
}
