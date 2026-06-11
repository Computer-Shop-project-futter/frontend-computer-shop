// ─────────────────────────────────────────────
//  G14 Admin — Add / Edit Component Sheet
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/models.dart';


class ComponentFormSheet extends StatefulWidget {
  final ComponentItem? existing; // null = add mode
  final ValueChanged<ComponentItem> onSave;

  const ComponentFormSheet({
    super.key,
    this.existing,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    ComponentItem? existing,
    required ValueChanged<ComponentItem> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ComponentFormSheet(existing: existing, onSave: onSave),
    );
  }

  @override
  State<ComponentFormSheet> createState() => _ComponentFormSheetState();
}

class _ComponentFormSheetState extends State<ComponentFormSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _priceCtrl;
  late ComponentCategory _category;

  static const _categories = [
    ComponentCategory.cpu,
    ComponentCategory.gpu,
    ComponentCategory.ram,
    ComponentCategory.storage,
    ComponentCategory.mb,
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl  = TextEditingController(text: e?.name ?? '');
    _brandCtrl = TextEditingController(text: e?.brand ?? '');
    _priceCtrl = TextEditingController(text: e?.price.replaceAll('\$', '') ?? '');
    _category  = e?.category ?? ComponentCategory.cpu;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty || _priceCtrl.text.trim().isEmpty) return;

    final item = ComponentItem(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      brand: _brandCtrl.text.trim(),
      price: '\$${_priceCtrl.text.trim()}',
      category: _category,
      isVisible: widget.existing?.isVisible ?? true,
    );
    widget.onSave(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Text(
            isEdit ? 'Edit Component' : 'Add Component',
            style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 18),

          // Name field
          _FormField(label: 'Component Name', controller: _nameCtrl,
              hint: 'e.g. Core i9-14900K'),
          const SizedBox(height: 12),

          // Brand field
          _FormField(label: 'Brand', controller: _brandCtrl,
              hint: 'e.g. Intel Corp.'),
          const SizedBox(height: 12),

          // Price field
          _FormField(label: 'Price (USD)', controller: _priceCtrl,
              hint: '0.00', keyboardType: TextInputType.number,
              prefix: '\$'),
          const SizedBox(height: 14),

          // Category picker
          const Text(
            'CATEGORY',
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700,
              color: Color(0xFF9CA3AF), letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _categories.map((c) {
              final sel = c == _category;
              return GestureDetector(
                onTap: () => setState(() => _category = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? c.badgeColor : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: sel ? c.badgeColor : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: sel ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                isEdit ? 'Save Changes' : 'Add Component',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? prefix;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700,
            color: Color(0xFF9CA3AF), letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}