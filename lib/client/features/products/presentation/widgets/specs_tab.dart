import 'package:flutter/material.dart';

import '../../domain/product_spec_model.dart';

class SpecsTab extends StatelessWidget {
	final List<ProductSpecModel> specs;

	const SpecsTab({
		super.key,
		required this.specs,
	});

	@override
	Widget build(BuildContext context) {
		if (specs.isEmpty) {
			return const Center(child: Text('No specs available.'));
		}

		return ListView.separated(
			padding: const EdgeInsets.all(12),
			itemCount: specs.length,
			separatorBuilder: (_, __) => const SizedBox(height: 8),
			itemBuilder: (context, index) {
				final spec = specs[index];
				final value = spec.unit == null
						? spec.specValue
						: '${spec.specValue} ${spec.unit}';
				return Container(
					padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
					decoration: BoxDecoration(
						color: index.isEven
								? Colors.grey.shade50
								: Colors.grey.shade100,
						borderRadius: BorderRadius.circular(10),
					),
					child: Row(
						children: [
							Expanded(
								child: Text(
									spec.specKey,
									style: const TextStyle(fontWeight: FontWeight.w600),
								),
							),
							Text(value),
						],
					),
				);
			},
		);
	}
}
