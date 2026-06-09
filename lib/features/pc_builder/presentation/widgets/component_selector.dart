// lib/features/builder/presentation/widgets/component_selector.dart

import 'package:computer_shop/features/shared/header/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/builder_model.dart';
import '../../data/builder_repository.dart';

class ComponentSelector extends ConsumerStatefulWidget {
  final ComponentType componentType;
  final Function(Component) onSelect;
  final VoidCallback onClose;

  const ComponentSelector({
    super.key,
    required this.componentType,
    required this.onSelect,
    required this.onClose,
  });

  @override
  ConsumerState<ComponentSelector> createState() => _ComponentSelectorState();
}

class _ComponentSelectorState extends ConsumerState<ComponentSelector> {
  CpuBrand? _selectedBrand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          AppHeaderBar(
            dark: false,
            child: Row(
              children: [
                AppHeaderIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: widget.onClose,
                  backgroundColor: const Color(0xFFF0F2F5),
                  iconColor: const Color(0xFF10213B),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'RIGBUILDER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF10213B),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search components...',
                  prefixIcon: Icon(Icons.search_rounded),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Brand Filters (for CPU only)
          if (widget.componentType == ComponentType.cpu)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedBrand == null,
                    onTap: () => setState(() => _selectedBrand = null),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'Intel',
                    isSelected: _selectedBrand == CpuBrand.intel,
                    onTap: () => setState(() => _selectedBrand = CpuBrand.intel),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'AMD',
                    isSelected: _selectedBrand == CpuBrand.amd,
                    onTap: () => setState(() => _selectedBrand = CpuBrand.amd),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Components List
          Expanded(
            child: FutureBuilder<List<Component>>(
              future: BuilderRepository().getComponentsByType(
                widget.componentType,
                brand: _selectedBrand,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final components = snapshot.data ?? [];
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: components.length,
                  itemBuilder: (context, index) {
                    final component = components[index];
                    final isSelected = false; // Check against current build
                    
                    return _ComponentItem(
                      component: component,
                      isSelected: isSelected,
                      onSelect: () => widget.onSelect(component),
                    );
                  },
                );
              },
            ),
          ),

          // Bottom Navigation
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavButton(label: 'Build', isSelected: true),
                    _NavButton(label: 'Parts', isSelected: false),
                    _NavButton(label: 'Guides', isSelected: false),
                    _NavButton(label: 'Save', isSelected: false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A66FF) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? const Color(0xFF2A66FF) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF10213B),
          ),
        ),
      ),
    );
  }
}

class _ComponentItem extends StatelessWidget {
  final Component component;
  final bool isSelected;
  final VoidCallback onSelect;

  const _ComponentItem({
    required this.component,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEAF1FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF2A66FF) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10213B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  component.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7891),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${component.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2A66FF),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onSelect,
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? const Color(0xFF2A66FF) : Colors.white,
              foregroundColor: isSelected ? Colors.white : const Color(0xFF2A66FF),
              side: isSelected ? null : const BorderSide(color: Color(0xFF2A66FF)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isSelected ? 'SELECTED' : 'SELECT'),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _NavButton({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? const Color(0xFF2A66FF) : const Color(0xFF6B7891),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 20,
            height: 2,
            color: isSelected ? const Color(0xFF2A66FF) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}