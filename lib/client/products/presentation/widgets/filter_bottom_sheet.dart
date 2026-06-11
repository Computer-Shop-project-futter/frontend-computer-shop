import 'package:flutter/material.dart';

import '../../data/products_repository.dart';

class FilterBottomSheet extends StatefulWidget {
  final ProductFilters initialFilters;
  final ValueChanged<ProductFilters> onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _priceRange;
  late bool _featuredOnly;
  late bool _dealOnly;
  late bool _inStockOnly;
  late Set<String> _categories;

  final List<String> _categoryOptions = const [
    'Gaming',
    'Workstations',
    'Peripherals',
    'Components',
  ];

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.initialFilters.minPrice ?? 500,
      widget.initialFilters.maxPrice ?? 4000,
    );
    _featuredOnly = widget.initialFilters.featuredOnly;
    _dealOnly = widget.initialFilters.dealOnly;
    _inStockOnly = widget.initialFilters.inStockOnly;
    _categories = widget.initialFilters.categoryIds.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'CATEGORY',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.1,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categoryOptions.map((category) {
                final isSelected = _categories.contains(category);
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _categories.add(category);
                      } else {
                        _categories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Price Range'),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 5000,
              divisions: 50,
              labels: RangeLabels(
                '\$${_priceRange.start.toStringAsFixed(0)}',
                '\$${_priceRange.end.toStringAsFixed(0)}',
              ),
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            SwitchListTile(
              value: _featuredOnly,
              onChanged: (value) => setState(() => _featuredOnly = value),
              title: const Text('Featured only'),
            ),
            SwitchListTile(
              value: _dealOnly,
              onChanged: (value) => setState(() => _dealOnly = value),
              title: const Text('On sale'),
            ),
            SwitchListTile(
              value: _inStockOnly,
              onChanged: (value) => setState(() => _inStockOnly = value),
              title: const Text('In stock'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: widget.onReset,
                  child: const Text('Reset'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    final filters = widget.initialFilters.copyWith(
                      categoryIds: _categories.toList(),
                      minPrice: _priceRange.start,
                      maxPrice: _priceRange.end,
                      featuredOnly: _featuredOnly,
                      dealOnly: _dealOnly,
                      inStockOnly: _inStockOnly,
                    );
                    widget.onApply(filters);
                  },
                  child: const Text('Show Results'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}