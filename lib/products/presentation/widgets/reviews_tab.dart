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
			return const Center(child: Text('No reviews yet.'));
		}

		final average = reviews
						.map((review) => review.rating)
						.fold<double>(0, (sum, value) => sum + value) /
				reviews.length;

		return ListView(
			padding: const EdgeInsets.all(12),
			children: [
				Text(
					'Average rating: ${average.toStringAsFixed(1)}',
					style: const TextStyle(fontWeight: FontWeight.w700),
				),
				const SizedBox(height: 12),
				...reviews.map(
					(review) => Container(
						margin: const EdgeInsets.only(bottom: 12),
						padding: const EdgeInsets.all(12),
						decoration: BoxDecoration(
							color: Colors.grey.shade50,
							borderRadius: BorderRadius.circular(12),
						),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Row(
									children: [
										Text(
											review.author,
											style: const TextStyle(fontWeight: FontWeight.w600),
										),
										const Spacer(),
										Text(review.rating.toStringAsFixed(1)),
									],
								),
								const SizedBox(height: 6),
								Text(
									review.title,
									style: const TextStyle(fontWeight: FontWeight.w600),
								),
								const SizedBox(height: 4),
								Text(review.body),
							],
						),
					),
				),
			],
		);
	}
}
