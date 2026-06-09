// ─────────────────────────────────────────────
//  G14 Admin — Components Screen
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../models/models.dart';
import 'card_component.dart';
import 'add_edit_component_page.dart';

class ComponentsScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const ComponentsScreen({super.key, required this.onMenuTap});

  @override
  State<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  late List<ComponentItem> _items;
  ComponentCategory _selectedCategory = ComponentCategory.all;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = List.from(ComponentData.items);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Filtered list ──────────────────────────
  List<ComponentItem> get _filtered {
    return _items.where((item) {
      final matchCat = _selectedCategory == ComponentCategory.all ||
          item.category == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchSearch = q.isEmpty ||
          item.name.toLowerCase().contains(q) ||
          item.brand.toLowerCase().contains(q);
      return matchCat && matchSearch;
    }).toList();
  }

  // ── Actions ────────────────────────────────
  Future<void> _onEdit(ComponentItem item) async {
    final updated = await Navigator.of(context).push<ComponentItem?>(
      MaterialPageRoute(builder: (_) => AddEditComponentPage(existing: item)),
    );
    if (updated != null) {
      setState(() {
        final idx = _items.indexWhere((e) => e.id == updated.id);
        if (idx >= 0) _items[idx] = updated;
      });
      _showSnack('${updated.name} updated', const Color(0xFF3B82F6));
    }
  }

  void _onDelete(ComponentItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Component',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          'Remove "${item.name}" from inventory?',
          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _items.removeWhere((e) => e.id == item.id));
              Navigator.pop(context);
              _showSnack('${item.name} deleted', const Color(0xFFEF4444));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onToggleVisibility(ComponentItem item) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == item.id);
      if (idx >= 0) {
        _items[idx] = item.copyWith(isVisible: !item.isVisible);
      }
    });
    final msg = item.isVisible ? 'Hidden from catalog' : 'Visible in catalog';
    _showSnack(msg, const Color(0xFF6B7280));
  }

  Future<void> _onAddNew() async {
    final newItem = await Navigator.of(context).push<ComponentItem?>(
      MaterialPageRoute(builder: (_) => const AddEditComponentPage()),
    );
    if (newItem != null) {
      setState(() => _items.insert(0, newItem));
      _showSnack('${newItem.name} added', const Color(0xFF10B981));
    }
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Column(
        children: [
          // ── App bar ───────────────────────
          _ComponentsAppBar(
            onMenuTap: widget.onMenuTap,
          ),

          // ── Search bar ────────────────────
          _SearchBar(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _searchQuery = v),
          ),

          const SizedBox(height: 10),

          // ── Category filter tabs ──────────
          CategoryFilterBar(
            selected: _selectedCategory,
            onChanged: (c) => setState(() => _selectedCategory = c),
          ),

          const SizedBox(height: 10),

          // ── Results count ─────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Text(
                  '${filtered.length} component${filtered.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 12, color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // ── List ──────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? _EmptyState(
                    onClear: () => setState(() {
                      _selectedCategory = ComponentCategory.all;
                      _searchQuery = '';
                      _searchCtrl.clear();
                    }),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => ComponentCard(
                      item: filtered[i],
                      onEdit: () => _onEdit(filtered[i]),
                      onDelete: () => _onDelete(filtered[i]),
                      onToggleVisibility: () =>
                          _onToggleVisibility(filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton.small(
          onPressed: _onAddNew,
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          tooltip: 'Add Product',
          child: const Icon(Icons.add_rounded, size: 20),
        ),
      ),
    );
  }
  
}

class CategoryFilterBar extends StatelessWidget {
  final ComponentCategory selected;
  final ValueChanged<ComponentCategory> onChanged;

  const CategoryFilterBar({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cats = ComponentCategory.values;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: List.generate(cats.length, (i) {
            final c = cats[i];
            final isSelected = c == selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onChanged(c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF4F5F7),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── App bar ────────────────────────────────────
class _ComponentsAppBar extends StatelessWidget {
  final VoidCallback onMenuTap;

  const _ComponentsAppBar({
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 4, right: 16, bottom: 10,
      ),
      child: Row(
        children: [
          // Menu button
          if (MediaQuery.of(context).size.width < 900)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded, size: 22),
              color: const Color(0xFF111827),
            ),

          // Brand + title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'G14-TECH',
                  style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w700,
                    color: Color(0xFF3B82F6), letterSpacing: 1,
                  ),
                ),
                Text(
                  'Components',
                  style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800,
                    color: Color(0xFF111827), letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ─────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: 'Search precision inventory…',
          hintStyle: const TextStyle(
              fontSize: 13.5, color: Color(0xFFBEC3CC)),
          prefixIcon: const Icon(Icons.search_rounded,
              color: Color(0xFFBEC3CC), size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0xFFBEC3CC), size: 18),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF4F5F7),
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 54,
              color: const Color(0x809CA3AF)),
          const SizedBox(height: 14),
          const Text(
            'No components found',
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different search or category.',
            style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}