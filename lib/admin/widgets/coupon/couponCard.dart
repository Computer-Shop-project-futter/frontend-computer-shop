// ─────────────────────────────────────────────
//  G14 Admin — Coupon Management Screen
// ─────────────────────────────────────────────

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/app_theme.dart';
import '../../models/models.dart';



class CouponScreen extends StatefulWidget {
  final VoidCallback onMenuTap;
  const CouponScreen({super.key, required this.onMenuTap});

  @override
  State<CouponScreen> createState() => CouponScreenState();
}

class CouponScreenState extends State<CouponScreen> {
  late List<CouponModel> coupons;
  CouponModel? _editing; // null = create new

  @override
  void initState() {
    super.initState();
    coupons = List.generate(12, (i) => CouponModel(
      id: 'c$i',
      code: 'SPRING${2025 + i}',
      description: 'Sample description for coupon code SPRING${2025 + i}.',
      discountType: (i % 2 == 0) ? DiscountType.percentage : DiscountType.fixed,
      discountValue: (i % 2 == 0) ? 15 : 10,
      minCartTotal: (i % 3 == 0) ? 50.0 : null,
      startDate: DateTime.now().subtract(Duration(days: i * 5)),
      endDate: DateTime.now().add(Duration(days: 30 - i * 2)),
      isActive: i % 4 != 0,
    ));
  }

  void _selectCoupon(CouponModel c) => setState(() => _editing = c);

  void _newCoupon() => setState(() => _editing = null);

  void _onSaved(CouponModel saved) {
    setState(() {
      final idx = coupons.indexWhere((c) => c.id == saved.id);
      if (idx >= 0) {
        coupons[idx] = saved;
      } else {
        coupons.insert(0, saved);
      }
      _editing = saved;
    });
    _snack('Coupon "${saved.code}" saved', C.accent);
  }

  void _onDelete(CouponModel c) {
    setState(() {
      coupons.removeWhere((x) => x.id == c.id);
      if (_editing?.id == c.id) _editing = null;
    });
    _snack('Coupon "${c.code}" deleted', C.red);
  }

  void _onToggle(CouponModel c) {
    setState(() {
      final idx = coupons.indexWhere((x) => x.id == c.id);
      if (idx >= 0) coupons[idx] = c.copyWith(isActive: !c.isActive);
      if (_editing?.id == c.id) _editing = coupons[idx];
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

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      backgroundColor: C.bg,
      body: Column(children: [
        _AppBar(onMenuTap: widget.onMenuTap, onNew: _newCoupon),
        Expanded(
          child: wide
              ? _WideLayout(
                  coupons: coupons,
                  editing: _editing,
                  onSelect: _selectCoupon,
                  onToggle: _onToggle,
                  onDelete: _onDelete,
                  onSaved: _onSaved,
                  onNew: _newCoupon,
                )
              : _NarrowLayout(
                  coupons: coupons,
                  onSelect: (c) {
                    _selectCoupon(c);
                    _openFormSheet(context, c);
                  },
                  onToggle: _onToggle,
                  onDelete: _onDelete,
                  onNew: () => _openFormSheet(context, null),
                ),
        ),
      ]),
    );
  }

  void _openFormSheet(BuildContext context, CouponModel? coupon) {
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
              child: CouponForm(
                key: ValueKey(coupon?.id ?? 'new'),
                coupon: coupon,
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
}

// ─────────────────────────────────────────────
//  Wide layout (tablet / desktop): list | form
// ─────────────────────────────────────────────
class _WideLayout extends StatelessWidget {
  final List<CouponModel> coupons;
  final CouponModel? editing;
  final ValueChanged<CouponModel> onSelect;
  final ValueChanged<CouponModel> onToggle;
  final ValueChanged<CouponModel> onDelete;
  final ValueChanged<CouponModel> onSaved;
  final VoidCallback onNew;

  const _WideLayout({
    required this.coupons, required this.editing,
    required this.onSelect, required this.onToggle,
    required this.onDelete, required this.onSaved, required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left: coupon list ──────────────────
        SizedBox(
          width: 310,
          child: CouponList(
            coupons: coupons,
            selectedId: editing?.id,
            onSelect: onSelect,
            onToggle: onToggle,
            onDelete: onDelete,
          ),
        ),
        // Divider
        Container(width: 1, color: C.border),
        // ── Right: form ────────────────────────
        Expanded(
          child: CouponForm(
            key: ValueKey(editing?.id ?? 'new'),
            coupon: editing,
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
  final List<CouponModel> coupons;
  final ValueChanged<CouponModel> onSelect;
  final ValueChanged<CouponModel> onToggle;
  final ValueChanged<CouponModel> onDelete;
  final VoidCallback onNew;

  const _NarrowLayout({
    required this.coupons, required this.onSelect,
    required this.onToggle, required this.onDelete, required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CouponList(
        coupons: coupons, selectedId: null,
        onSelect: onSelect, onToggle: onToggle, onDelete: onDelete,
      ),
      Positioned(
        bottom: 80, right: 16,
        child: FloatingActionButton(
          onPressed: onNew,
          backgroundColor: C.accent,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.add_rounded),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  Coupon list
// ─────────────────────────────────────────────
class CouponList extends StatelessWidget {
  final List<CouponModel> coupons;
  final String? selectedId;
  final ValueChanged<CouponModel> onSelect;
  final ValueChanged<CouponModel> onToggle;
  final ValueChanged<CouponModel> onDelete;

  const CouponList({
    required this.coupons, required this.selectedId,
    required this.onSelect, required this.onToggle, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return const Center(
        child: Text('No coupons yet.',
            style: TextStyle(color: C.textMuted, fontSize: 14)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: coupons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (_, i) => CouponCard(
        coupon: coupons[i],
        isSelected: coupons[i].id == selectedId,
        onTap: () => onSelect(coupons[i]),
        onToggle: () => onToggle(coupons[i]),
        onEdit: () => onSelect(coupons[i]),
        onDelete: () => confirmDelete(context, coupons[i]),
      ),
    );
  }

  void confirmDelete(BuildContext context, CouponModel c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Delete Coupon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('Delete coupon "${c.code}"? This cannot be undone.',
            style: const TextStyle(fontSize: 13.5, color: C.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: C.textMuted)),
          ),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); onDelete(c); },
            style: ElevatedButton.styleFrom(
              backgroundColor: C.red, foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Single coupon card
// ─────────────────────────────────────────────
class CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CouponCard({
    required this.coupon, required this.isSelected,
    required this.onTap, required this.onToggle,
    required this.onEdit, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final status = coupon.status;
    final isExpired = status == CouponStatus.expired;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? C.accent : C.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: C.accent.withOpacity(0.12),
                  blurRadius: 8, offset: const Offset(0, 2))]
              : [const BoxShadow(color: Color(0x08000000),
                  blurRadius: 4, offset: Offset(0, 1))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: code + badge + toggle
            Row(children: [
              Expanded(
                child: Text(coupon.code,
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800,
                      color: isExpired ? C.textMuted : C.textPrimary,
                      letterSpacing: 0.2,
                    )),
              ),
              _StatusBadge(status: status,
                  type: coupon.discountType),
              const SizedBox(width: 10),
              // Toggle (disabled if expired)
              GestureDetector(
                onTap: isExpired ? null : onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 42, height: 24,
                  decoration: BoxDecoration(
                    color: (!isExpired && coupon.isActive)
                        ? C.accent
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 180),
                    alignment: (!isExpired && coupon.isActive)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 20, height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                            color: Color(0x22000000), blurRadius: 3)],
                      ),
                    ),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 4),

            // Summary line
            Text(coupon.summaryLine,
                style: TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w600,
                  color: isExpired ? C.textMuted : C.textPrimary,
                )),

            const SizedBox(height: 2),

            // Date range
            Text(coupon.dateRange,
                style: const TextStyle(fontSize: 11.5, color: C.textMuted)),

            const SizedBox(height: 8),
            const Divider(height: 1, color: C.border),
            const SizedBox(height: 6),

            // Action row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isExpired)
                  const Icon(Icons.history_rounded,
                      size: 18, color: C.textMuted)
                else
                  GestureDetector(
                    onTap: onEdit,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.edit_outlined,
                          size: 18, color: C.accent),
                    ),
                  ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: onDelete,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.delete_outline_rounded,
                        size: 18, color: C.red),
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

// ─────────────────────────────────────────────
//  Status badge
// ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final CouponStatus status;
  final DiscountType type;
  const _StatusBadge({required this.status, required this.type});

  @override
  Widget build(BuildContext context) {
    Color bg; Color fg; String label;

    if (status == CouponStatus.expired) {
      bg = const Color(0xFFF1F5F9); fg = C.textMuted;
      label = 'EXPIRED';
    } else {
      bg = (type == DiscountType.percentage)
          ? const Color(0xFFEFF6FF)
          : const Color(0xFFF0FDF4);
      fg = (type == DiscountType.percentage)
          ? C.accent
          : const Color(0xFF16A34A);
      label = type.label;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700,
              color: fg, letterSpacing: 0.4)),
    );
  }
}

// ─────────────────────────────────────────────
//  Coupon form (create / edit)
// ─────────────────────────────────────────────
class CouponForm extends StatefulWidget {
  final CouponModel? coupon;
  final ValueChanged<CouponModel> onSaved;

  const CouponForm({super.key, this.coupon, required this.onSaved});

  @override
  State<CouponForm> createState() => CouponFormState();
}

class CouponFormState extends State<CouponForm> {
  late final TextEditingController codeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _valueCtrl;
  late final TextEditingController _minCartCtrl;
  late DiscountType _discountType;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final c = widget.coupon;
    codeCtrl    = TextEditingController(text: c?.code ?? _generateCode());
    _descCtrl    = TextEditingController(text: c?.description ?? '');
    _valueCtrl   = TextEditingController(
        text: c != null ? c.discountValue.toStringAsFixed(0) : '20');
    _minCartCtrl = TextEditingController(
        text: c?.minCartTotal != null
            ? c!.minCartTotal!.toStringAsFixed(2)
            : '');
    _discountType = c?.discountType ?? DiscountType.percentage;
    _startDate    = c?.startDate ?? DateTime.now();
    _endDate      = c?.endDate   ?? DateTime.now().add(const Duration(days: 90));
    _isActive     = c?.isActive  ?? true;
  }

  @override
  void dispose() {
    codeCtrl.dispose(); _descCtrl.dispose();
    _valueCtrl.dispose(); _minCartCtrl.dispose();
    super.dispose();
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random();
    return List.generate(8, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  void _onGenerate() {
    setState(() => codeCtrl.text = _generateCode());
  }

  void _submit() {
    final code = codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showError('Coupon code cannot be empty.');
      return;
    }
    final val = double.tryParse(_valueCtrl.text.trim());
    if (val == null || val <= 0) {
      _showError('Enter a valid discount value.');
      return;
    }
    final minCart = double.tryParse(_minCartCtrl.text.trim());

    final saved = CouponModel(
      id: widget.coupon?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      code: code,
      description: _descCtrl.text.trim(),
      discountType: _discountType,
      discountValue: val,
      minCartTotal: minCart,
      startDate: _startDate,
      endDate: _endDate,
      isActive: _isActive,
    );
    widget.onSaved(saved);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: C.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: C.accent),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() => isStart ? _startDate = picked : _endDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.coupon != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(children: [
            Expanded(
              child: Text(isEdit ? 'Edit Coupon' : 'Create Coupon',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800,
                      color: C.textPrimary)),
            ),
            GestureDetector(
              onTap: _submit,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  color: C.accent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                      color: C.accent.withOpacity(0.3),
                      blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: const Text('Save',
                    style: TextStyle(color: Colors.white,
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),

          const SizedBox(height: 20),

          // ── Coupon code ────────────────────
          _FieldLabel('COUPON CODE'),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(
              child: TextField(
                controller: codeCtrl,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: C.textPrimary, letterSpacing: 0.5),
                decoration: _inputDeco(hint: 'e.g. SPRING2025'),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _onGenerate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Icon(Icons.refresh_rounded,
                      color: Colors.white, size: 15),
                  SizedBox(width: 6),
                  Text('GENERATE',
                      style: TextStyle(color: Colors.white,
                          fontSize: 11, fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                ]),
              ),
            ),
          ]),

          const SizedBox(height: 18),

          // ── Description ────────────────────
          _FieldLabel('DESCRIPTION (OPTIONAL)'),
          const SizedBox(height: 6),
          TextField(
            controller: _descCtrl,
            maxLines: 2,
            style: const TextStyle(fontSize: 13.5, color: C.textPrimary),
            decoration: _inputDeco(
                hint: 'e.g. 20% off for all spring items…'),
          ),

          const SizedBox(height: 18),

          // ── Discount type toggle ───────────
          _FieldLabel('DISCOUNT TYPE'),
          const SizedBox(height: 8),
          _DiscountTypeToggle(
            selected: _discountType,
            onChanged: (t) => setState(() => _discountType = t),
          ),

          const SizedBox(height: 18),

          // ── Discount value ─────────────────
          _FieldLabel('DISCOUNT VALUE'),
          const SizedBox(height: 8),
          _DiscountValueField(
            controller: _valueCtrl,
            type: _discountType,
          ),

          const SizedBox(height: 18),

          // ── Min cart total ─────────────────
          _FieldLabel('MIN CART TOTAL (OPTIONAL)'),
          const SizedBox(height: 6),
          TextField(
            controller: _minCartCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
            ],
            style: const TextStyle(fontSize: 13.5, color: C.textPrimary),
            decoration: _inputDeco(
              hint: '0.00',
              prefixText: '\$ ',
            ),
          ),

          const SizedBox(height: 18),

          // ── Dates ──────────────────────────
          _FieldLabel('START DATE'),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(child: _DateField(
              date: _startDate,
              onTap: () => _pickDate(true),
            )),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel('END DATE'),
                const SizedBox(height: 6),
                _DateField(
                  date: _endDate,
                  onTap: () => _pickDate(false),
                ),
              ],
            )),
          ]),

          const SizedBox(height: 20),

          // ── Active status ──────────────────
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: C.border),
            ),
            child: Row(children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Active Status',
                      style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: C.textPrimary)),
                  SizedBox(height: 2),
                  Text('Coupon is visible to customers',
                      style: TextStyle(fontSize: 12,
                          color: C.textMuted)),
                ],
              )),
              GestureDetector(
                onTap: () => setState(() => _isActive = !_isActive),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48, height: 26,
                  decoration: BoxDecoration(
                    color: _isActive
                        ? C.accent
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _isActive
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 22, height: 22,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                            color: Color(0x22000000), blurRadius: 4)],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    String? prefixText,
  }) =>
      InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
        filled: true,
        fillColor: C.bg,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: C.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: C.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: C.accent, width: 1.5)),
      );
}

// ─────────────────────────────────────────────
//  Discount type toggle (Percent % | Fixed $)
// ─────────────────────────────────────────────
class _DiscountTypeToggle extends StatelessWidget {
  final DiscountType selected;
  final ValueChanged<DiscountType> onChanged;

  const _DiscountTypeToggle(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: C.border),
      ),
      child: Row(children: [
        _Tab(
          label: 'Percent %',
          isSelected: selected == DiscountType.percentage,
          onTap: () => onChanged(DiscountType.percentage),
          isFirst: true,
        ),
        _Tab(
          label: 'Fixed \$',
          isSelected: selected == DiscountType.fixed,
          onTap: () => onChanged(DiscountType.fixed),
          isFirst: false,
        ),
      ]),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;

  const _Tab({
    required this.label, required this.isSelected,
    required this.onTap, required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [const BoxShadow(color: Color(0x14000000),
                    blurRadius: 4, offset: Offset(0, 1))]
                : [],
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5, fontWeight: FontWeight.w700,
                color: isSelected ? C.textPrimary : C.textMuted,
              )),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Large discount value display field
// ─────────────────────────────────────────────
class _DiscountValueField extends StatelessWidget {
  final TextEditingController controller;
  final DiscountType type;

  const _DiscountValueField(
      {required this.controller, required this.type});

  @override
  Widget build(BuildContext context) {
    final suffix = type == DiscountType.percentage ? '%' : '\$';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: C.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: C.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IntrinsicWidth(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40, fontWeight: FontWeight.w800,
                color: C.textPrimary, letterSpacing: -1,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(suffix,
              style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700,
                color: C.textMuted,
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Date picker field
// ─────────────────────────────────────────────
class _DateField extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        decoration: BoxDecoration(
          color: C.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: C.border),
        ),
        child: Row(children: [
          Expanded(
            child: Text(formatted,
                style: const TextStyle(
                    fontSize: 13.5, color: C.textPrimary,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.calendar_month_outlined,
              size: 17, color: C.textMuted),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  App bar
// ─────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onNew;

  const _AppBar({required this.onMenuTap, required this.onNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 4, right: 14, bottom: 10,
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: C.border))),
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
              Text('G14-TECH',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: C.accent, letterSpacing: 1)),
              Text('Coupons',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                      color: C.textPrimary, letterSpacing: -0.4)),
            ],
          ),
        ),
        // + New button (shown on narrow layout in appbar)
        if (MediaQuery.of(context).size.width < 720)
          GestureDetector(
            onTap: onNew,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: C.accent,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [BoxShadow(color: C.accent.withOpacity(0.3),
                    blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: const Text('+ New',
                  style: TextStyle(color: Colors.white,
                      fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared helpers
// ─────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 10, fontWeight: FontWeight.w700,
          color: C.textMuted, letterSpacing: 0.6));
}

