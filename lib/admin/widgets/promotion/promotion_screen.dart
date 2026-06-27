// ─────────────────────────────────────────────
//  G14 Admin — Promotion Management Screen
// ─────────────────────────────────────────────

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/app_theme.dart';
import '../../models/models.dart';

class PromotionScreen extends StatefulWidget {
  final VoidCallback onMenuTap;
  const PromotionScreen({super.key, required this.onMenuTap});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  late List<PromotionItem> promotions;
  PromotionItem? _editing;

  @override
  void initState() {
    super.initState();
    promotions = PromotionData.seed;
  }

  void _selectPromotion(PromotionItem p) => setState(() => _editing = p);

  void _newPromotion() => setState(() => _editing = null);

  void _onSaved(PromotionItem saved) {
    setState(() {
      final idx = promotions.indexWhere((p) => p.id == saved.id);
      if (idx >= 0) {
        promotions[idx] = saved;
      } else {
        promotions.insert(0, saved);
      }
      _editing = saved;
    });
    _snack('Promotion "${saved.title}" saved', C.accent);
  }

  void _onDelete(PromotionItem p) {
    setState(() {
      promotions.removeWhere((x) => x.id == p.id);
      if (_editing?.id == p.id) _editing = null;
    });
    _snack('Promotion "${p.title}" deleted', C.red);
  }

  void _onToggle(PromotionItem p) {
    setState(() {
      final idx = promotions.indexWhere((x) => x.id == p.id);
      if (idx >= 0) promotions[idx] = p.copyWith(isActive: !p.isActive);
      if (_editing?.id == p.id) _editing = promotions[idx];
    });
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
  }

  void _openFormSheet(BuildContext context, PromotionItem? promo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.98,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(children: [
            _sheetHandle(),
            Expanded(
              child: PromotionForm(
                key: ValueKey(promo?.id ?? 'new'),
                promotion: promo,
                onSaved: (saved) {
                  _onSaved(saved);
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _sheetHandle() => Center(
        child: Container(
          width: 36, height: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: C.border, borderRadius: BorderRadius.circular(2)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(children: [
          _AppBar(onMenuTap: widget.onMenuTap, onNew: _newPromotion),
          Expanded(
            child: wide
                ? _WideLayout(
                    promotions: promotions,
                    editing: _editing,
                    onSelect: _selectPromotion,
                    onToggle: _onToggle,
                    onDelete: _onDelete,
                    onSaved: _onSaved,
                    onNew: _newPromotion,
                  )
                : _NarrowLayout(
                    promotions: promotions,
                    onSelect: (p) {
                      _selectPromotion(p);
                      _openFormSheet(context, p);
                    },
                    onToggle: _onToggle,
                    onDelete: _onDelete,
                    onNew: () => _openFormSheet(context, null),
                  ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Wide layout (tablet / desktop): list | form
// ─────────────────────────────────────────────
class _WideLayout extends StatelessWidget {
  final List<PromotionItem> promotions;
  final PromotionItem? editing;
  final ValueChanged<PromotionItem> onSelect;
  final ValueChanged<PromotionItem> onToggle;
  final ValueChanged<PromotionItem> onDelete;
  final ValueChanged<PromotionItem> onSaved;
  final VoidCallback onNew;

  const _WideLayout({
    required this.promotions, required this.editing,
    required this.onSelect, required this.onToggle,
    required this.onDelete, required this.onSaved, required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 310,
          child: PromotionList(
            promotions: promotions,
            selectedId: editing?.id,
            onSelect: onSelect,
            onToggle: onToggle,
            onDelete: onDelete,
          ),
        ),
        Container(width: 1, color: C.border),
        Expanded(
          child: PromotionForm(
            key: ValueKey(editing?.id ?? 'new'),
            promotion: editing,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Narrow layout: list only, form opens as sheet
// ─────────────────────────────────────────────
class _NarrowLayout extends StatelessWidget {
  final List<PromotionItem> promotions;
  final ValueChanged<PromotionItem> onSelect;
  final ValueChanged<PromotionItem> onToggle;
  final ValueChanged<PromotionItem> onDelete;
  final VoidCallback onNew;

  const _NarrowLayout({
    required this.promotions, required this.onSelect,
    required this.onToggle, required this.onDelete, required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 88),
      child: Stack(children: [
        PromotionList(
          promotions: promotions, selectedId: null,
          onSelect: onSelect, onToggle: onToggle, onDelete: onDelete,
        ),
        Positioned(
          bottom: 16, right: 16,
          child: FloatingActionButton(
            onPressed: onNew,
            backgroundColor: C.accent,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Promotion list
// ─────────────────────────────────────────────
class PromotionList extends StatelessWidget {
  final List<PromotionItem> promotions;
  final String? selectedId;
  final ValueChanged<PromotionItem> onSelect;
  final ValueChanged<PromotionItem> onToggle;
  final ValueChanged<PromotionItem> onDelete;

  const PromotionList({
    super.key,
    required this.promotions,
    required this.selectedId,
    required this.onSelect,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) {
      return const Center(
        child: Text('No promotions yet', style: TextStyle(color: C.textMuted)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
      itemCount: promotions.length,
      itemBuilder: (_, i) {
        final p = promotions[i];
        final selected = p.id == selectedId;
        return PromotionCard(
          promotion: p,
          isSelected: selected,
          onTap: () => onSelect(p),
          onToggle: () => onToggle(p),
          onDelete: () => onDelete(p),
        );
      },
    );
  }
}

class PromotionCard extends StatelessWidget {
  final PromotionItem promotion;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const PromotionCard({
    super.key,
    required this.promotion,
    required this.isSelected,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = promotion.imagePath != null && promotion.imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? C.accent : C.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x09000000), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image / fallback icon
            Container(
              width: 52, height: 52,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: promotion.type.badgeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: hasImage
                  ? Image.memory(base64Decode(promotion.imagePath!), fit: BoxFit.cover)
                  : Icon(Icons.campaign_rounded, color: promotion.type.badgeColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          promotion.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StatusPill(label: promotion.statusLabel, color: promotion.statusColor),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    promotion.subtitle,
                    style: const TextStyle(fontSize: 12, color: C.textMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _TypeBadge(type: promotion.type),
                      const SizedBox(width: 8),
                      Text(promotion.dateRange,
                          style: const TextStyle(fontSize: 10.5, color: C.textMuted, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: promotion.isActive,
                  onChanged: (_) => onToggle(),
                  activeColor: C.accent,
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.delete_outline_rounded, size: 18, color: C.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.4)),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final PromotionType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: type.badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(type.label,
          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: type.badgeColor)),
    );
  }
}

// ─────────────────────────────────────────────
//  Promotion form
// ─────────────────────────────────────────────
class PromotionForm extends StatefulWidget {
  final PromotionItem? promotion;
  final ValueChanged<PromotionItem> onSaved;

  const PromotionForm({super.key, this.promotion, required this.onSaved});

  @override
  State<PromotionForm> createState() => _PromotionFormState();
}

class _PromotionFormState extends State<PromotionForm> {
  late TextEditingController _titleCtrl;
  late TextEditingController _subtitleCtrl;
  late PromotionType _type;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _isActive;
  String? _imageBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadFrom(widget.promotion);
  }

  @override
  void didUpdateWidget(PromotionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.promotion?.id != widget.promotion?.id) {
      _loadFrom(widget.promotion);
    }
  }

  void _loadFrom(PromotionItem? p) {
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _subtitleCtrl = TextEditingController(text: p?.subtitle ?? '');
    _type = p?.type ?? PromotionType.banner;
    _startDate = p?.startDate ?? DateTime.now();
    _endDate = p?.endDate ?? DateTime.now().add(const Duration(days: 7));
    _isActive = p?.isActive ?? true;
    _imageBase64 = p?.imagePath;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _imageBase64 = base64Encode(bytes));
    }
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) return;
    final item = PromotionItem(
      id: widget.promotion?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      subtitle: _subtitleCtrl.text.trim(),
      type: _type,
      startDate: _startDate,
      endDate: _endDate,
      isActive: _isActive,
      imagePath: _imageBase64,
    );
    widget.onSaved(item);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.promotion != null;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEdit ? 'Edit Promotion' : 'New Promotion',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.textPrimary),
          ),
          const SizedBox(height: 18),

          const Text('BANNER IMAGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: C.textMuted, letterSpacing: 0.6)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 120,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.border),
              ),
              child: (_imageBase64 != null && _imageBase64!.isNotEmpty)
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(base64Decode(_imageBase64!), fit: BoxFit.cover),
                        Positioned(
                          right: 8, bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: C.accent, shape: BoxShape.circle),
                            child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, color: C.textMuted, size: 28),
                          SizedBox(height: 6),
                          Text('Tap to upload banner', style: TextStyle(fontSize: 12, color: C.textMuted)),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          _FieldLabel('Title'),
          const SizedBox(height: 6),
          _TextInput(controller: _titleCtrl, hint: 'e.g. Summer GPU Blowout'),
          const SizedBox(height: 14),

          _FieldLabel('Subtitle / Description'),
          const SizedBox(height: 6),
          _TextInput(controller: _subtitleCtrl, hint: 'Short promo description', maxLines: 2),
          const SizedBox(height: 16),

          _FieldLabel('Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: PromotionType.values.map((t) {
              final sel = t == _type;
              return GestureDetector(
                onTap: () => setState(() => _type = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? t.badgeColor : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: sel ? t.badgeColor : C.border),
                  ),
                  child: Text(t.label,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? Colors.white : C.textSecondary)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _DatePickerField(label: 'Start Date', date: _startDate, onTap: () => _pickDate(isStart: true)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DatePickerField(label: 'End Date', date: _endDate, onTap: () => _pickDate(isStart: false)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Switch(value: _isActive, onChanged: (v) => setState(() => _isActive = v), activeColor: C.accent),
              const SizedBox(width: 4),
              Text(_isActive ? 'Active' : 'Inactive',
                  style: const TextStyle(color: C.textSecondary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: C.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(isEdit ? 'Save Changes' : 'Create Promotion',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DatePickerField({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: C.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 15, color: C.textMuted),
                const SizedBox(width: 8),
                Text('${date.month}/${date.day}/${date.year}',
                    style: const TextStyle(fontSize: 13, color: C.textPrimary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: C.textMuted, letterSpacing: 0.6));
  }
}

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _TextInput({required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: C.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.accent, width: 1.5)),
      ),
    );
  }
}

// ── App bar ────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onNew;

  const _AppBar({required this.onMenuTap, required this.onNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 4, right: 14, bottom: 10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: C.border)),
      ),
      child: Row(children: [
        if (MediaQuery.of(context).size.width < 720)
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu_rounded, size: 22),
            color: C.textPrimary,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('G14-TECH', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: C.accent, letterSpacing: 1)),
              Text('Promotions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: C.textPrimary, letterSpacing: -0.4)),
            ],
          ),
        ),
        if (MediaQuery.of(context).size.width >= 720)
          GestureDetector(
            onTap: onNew,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: C.accent,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [BoxShadow(color: C.accent.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: const Text('+ New Promotion', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          )
        else
          GestureDetector(
            onTap: onNew,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: C.accent,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [BoxShadow(color: C.accent.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: const Text('+ New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
      ]),
    );
  }
}
