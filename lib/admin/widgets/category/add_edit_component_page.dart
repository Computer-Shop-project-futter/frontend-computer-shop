// ─────────────────────────────────────────────
//  G14 Admin — Add / Edit Component Page
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/models.dart';

class AddEditComponentPage extends StatefulWidget {
  final ComponentItem? existing;

  const AddEditComponentPage({super.key, this.existing});

  @override
  State<AddEditComponentPage> createState() => _AddEditComponentPageState();
}

class _AddEditComponentPageState extends State<AddEditComponentPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descriptionCtrl;
  late ComponentCategory _category;
  bool _isVisible = true;

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
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _brandCtrl = TextEditingController(text: e?.brand ?? '');
    _priceCtrl = TextEditingController(text: e?.price.replaceAll('\$', '') ?? '');
    _descriptionCtrl = TextEditingController(text: e?.description ?? '');
    _category = e?.category ?? ComponentCategory.cpu;
    _isVisible = e?.isVisible ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _priceCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty || _priceCtrl.text.trim().isEmpty) return;
    final item = ComponentItem(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      brand: _brandCtrl.text.trim(),
      price: '\$${_priceCtrl.text.trim()}',
      category: _category,
      description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      isVisible: _isVisible,
    );
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEdit ? 'Edit Component' : 'Add Component',
          style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FormField(label: 'Component Name', controller: _nameCtrl, hint: 'e.g. Core i9-13900K'),
            const SizedBox(height: 12),
            _FormField(label: 'Brand', controller: _brandCtrl, hint: 'e.g. Intel Corp.'),
            const SizedBox(height: 12),
            _FormField(label: 'Price (USD)', controller: _priceCtrl, hint: '0.00', keyboardType: TextInputType.number, prefix: '\$'),
            const SizedBox(height: 12),
            _FormField(
              label: 'Product Summary',
              controller: _descriptionCtrl,
              hint: 'Short advantage or recommended use',
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            const SizedBox(height: 18),

            const Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 0.6)),
            const SizedBox(height: 8),
            Row(
              children: [
                Switch(value: _isVisible, onChanged: (v) => setState(() => _isVisible = v)),
                const SizedBox(width: 8),
                Text(_isVisible ? 'Active' : 'Hidden', style: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 16),
            const Text('CATEGORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 0.6)),
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
                      border: Border.all(color: sel ? c.badgeColor : const Color(0xFFE5E7EB)),
                    ),
                    child: Text(c.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? Colors.white : const Color(0xFF6B7280))),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),

      // Sticky save button near footer
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: SizedBox(
          width: 360,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: Text(isEdit ? 'Save Changes' : 'Add Component', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final String? prefix;

  const _FormField({required this.label, required this.hint, required this.controller, this.keyboardType = TextInputType.text, this.maxLines = 1, this.prefix});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 0.6)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
          ),
        ),
      ],
    );
  }
}
