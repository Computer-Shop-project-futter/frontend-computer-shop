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
			return const Center(child: Text('No benchmarks available.'));
		}

		return ListView.separated(
			padding: const EdgeInsets.all(12),
			itemCount: benchmarks.length,
			separatorBuilder: (_, __) => const SizedBox(height: 12),
			itemBuilder: (context, index) {
				final metric = benchmarks[index];
				return Container(
					padding: const EdgeInsets.all(12),
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(12),
						color: Colors.grey.shade50,
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								metric.metricKey,
								style: const TextStyle(fontWeight: FontWeight.w600),
							),
							const SizedBox(height: 6),
							Text(metric.metricValue),
							const SizedBox(height: 8),
							LinearProgressIndicator(
								value: metric.barPercent.clamp(0, 1),
								minHeight: 8,
								borderRadius: BorderRadius.circular(6),
							),
						],
					),
				);
			},
		);
	}
}
