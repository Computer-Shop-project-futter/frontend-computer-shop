import 'package:flutter/material.dart';

import '../../domain/product_benchmark_model.dart';

class BenchmarksTab extends StatelessWidget {
	final List<ProductBenchmarkModel> benchmarks;

	const BenchmarksTab({
		super.key,
		required this.benchmarks,
	});

	@override
	Widget build(BuildContext context) {
		if (benchmarks.isEmpty) {
			return const Center(
				child: Text(
					'No benchmarks available.',
					style: TextStyle(
						color: Color(0xFF6B7891),
						fontWeight: FontWeight.w600,
					),
				),
			);
		}

		return ListView.separated(
			padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
			itemCount: benchmarks.length,
			separatorBuilder: (_, __) => const SizedBox(height: 12),
			itemBuilder: (context, index) {
				final metric = benchmarks[index];
				final score = metric.barPercent.clamp(0, 1).toDouble();
				return Container(
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
									Expanded(
										child: Text(
											metric.metricKey.toUpperCase(),
											style: const TextStyle(
												color: Color(0xFF10213B),
												fontSize: 12,
												fontWeight: FontWeight.w900,
												letterSpacing: 0.8,
											),
										),
									),
									Container(
										padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
										decoration: BoxDecoration(
											color: const Color(0xFFEAF1FF),
											borderRadius: BorderRadius.circular(999),
										),
										child: Text(
											metric.metricValue,
											style: const TextStyle(
												color: Color(0xFF2A66FF),
												fontSize: 10,
												fontWeight: FontWeight.w900,
											),
										),
									),
								],
							),
							Text(
								'${(score * 100).round()}% performance score',
								style: const TextStyle(fontWeight: FontWeight.w600),
							),
							const SizedBox(height: 10),
							Text(metric.metricValue),
							const SizedBox(height: 8),
							LinearProgressIndicator(
								value: score,
								minHeight: 10,
								backgroundColor: const Color(0xFFEAF1FF),
								valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2A66FF)),
								borderRadius: BorderRadius.circular(999),
							),
						],
					),
				);
			},
		);
	}
}
