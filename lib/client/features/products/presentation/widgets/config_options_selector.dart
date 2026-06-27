import 'package:flutter/material.dart';

import '../../domain/product_config_option_model.dart';

class ConfigOptionsSelector extends StatelessWidget {
	final List<ProductConfigOptionModel> options;
	final Map<String, ProductConfigOptionModel> selectedOptions;
	final ValueChanged<ProductConfigOptionModel> onSelect;

	const ConfigOptionsSelector({
		super.key,
		required this.options,
		required this.selectedOptions,
		required this.onSelect,
	});

	@override
	Widget build(BuildContext context) {
		if (options.isEmpty) {
			return const SizedBox.shrink();
		}

		final groups = <String, List<ProductConfigOptionModel>>{};
		for (final option in options) {
			groups.putIfAbsent(option.optionGroup, () => []).add(option);
		}

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: groups.entries.map((entry) {
				final group = entry.key;
				final groupOptions = entry.value;
				return Padding(
					padding: const EdgeInsets.only(bottom: 12),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								group,
								style: const TextStyle(fontWeight: FontWeight.w700),
							),
							const SizedBox(height: 8),
							Wrap(
								spacing: 8,
								children: groupOptions.map((option) {
									final isSelected = selectedOptions[group]?.optionId ==
											option.optionId;
									final priceLabel = option.priceDelta == 0
											? option.optionLabel
											: '${option.optionLabel} (+\$${option.priceDelta.toStringAsFixed(0)})';
									return ChoiceChip(
										label: Text(priceLabel),
										selected: isSelected,
										onSelected: (_) => onSelect(option),
									);
								}).toList(),
							),
						],
					),
				);
			}).toList(),
		);
	}
}
