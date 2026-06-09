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
    const brandBlue = Color(0xFF2A66FF);
    const deepBlue = Color(0xFF12306A);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 24,
              offset: Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 54,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E2FB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.tune_rounded, color: brandBlue),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Shop Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: deepBlue,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Refine blue-and-white hardware picks by category, price, and availability.',
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                _FilterSectionCard(
                  title: 'CATEGORY',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categoryOptions.map((category) {
                      final isSelected = _categories.contains(category);
                      return _CategoryChoiceChip(
                        label: category,
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _categories.remove(category);
                            } else {
                              _categories.add(category);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _FilterSectionCard(
                  title: 'PRICE RANGE',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _PriceTag(label: 'Min', value: _priceRange.start),
                          const Spacer(),
                          _PriceTag(label: 'Max', value: _priceRange.end),
                        ],
                      ),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 5000,
                        divisions: 50,
                        activeColor: brandBlue,
                        inactiveColor: const Color(0xFFDCE6FB),
                        labels: RangeLabels(
                          '\$${_priceRange.start.toStringAsFixed(0)}',
                          '\$${_priceRange.end.toStringAsFixed(0)}',
                        ),
                        onChanged: (values) =>
                            setState(() => _priceRange = values),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _FilterSectionCard(
                  title: 'AVAILABILITY',
                  child: Column(
                    children: [
                      _BlueSwitchTile(
                        title: 'Featured only',
                        value: _featuredOnly,
                        onChanged: (value) =>
                            setState(() => _featuredOnly = value),
                      ),
                      _BlueSwitchTile(
                        title: 'On sale',
                        value: _dealOnly,
                        onChanged: (value) => setState(() => _dealOnly = value),
                      ),
                      _BlueSwitchTile(
                        title: 'In stock',
                        value: _inStockOnly,
                        onChanged: (value) =>
                            setState(() => _inStockOnly = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: widget.onReset,
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: brandBlue,
                        side: const BorderSide(color: Color(0xFFBFD0FA)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
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
                        icon: const Icon(Icons.search_rounded),
                        label: const Text('Show Results'),
                        style: FilledButton.styleFrom(
                          backgroundColor: brandBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDCE6FB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.1,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _CategoryChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2A66FF) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFF2A66FF) : const Color(0xFFCAD8F7),
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFF2A66FF).withOpacity(0.18)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF12306A),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final String label;
  final double value;

  const _PriceTag({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE6FB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${value.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Color(0xFF12306A),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlueSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BlueSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF12306A),
          fontWeight: FontWeight.w700,
        ),
      ),
      activeColor: const Color(0xFF2A66FF),
      activeTrackColor: const Color(0xFFBFD0FA),
    );
  }
}
