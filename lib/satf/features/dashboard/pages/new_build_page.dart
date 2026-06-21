import 'package:flutter/material.dart';
import '../../../../admin/models/models.dart';
import '../../../../admin/shared/component_store.dart';
import '../models/recent_build_model.dart';
import '../app_theme.dart';

// ── Helper: convert ComponentItem → _Part ────────────────────────────────────

List<_Part> _partsFromCategory(ComponentCategory cat) {
  return ComponentStore.items
      .where((item) => item.category == cat && item.isVisible)
      .map((item) {
    final price = double.tryParse(
          item.price.replaceAll(RegExp(r'[^\d.]'), ''),
        ) ??
        0;
    return _Part(item.name, item.description ?? item.brand, price);
  }).toList();
}

class _Part {
  final String name;
  final String detail;
  final double price;
  const _Part(this.name, this.detail, this.price);
}

// ── Page ──────────────────────────────────────────────────────────────────────

class NewBuildPage extends StatefulWidget {
  final void Function(RecentBuildModel build)? onBuildCreated;
  final String? initialCustomerName;

  const NewBuildPage({super.key, this.onBuildCreated, this.initialCustomerName});

  @override
  State<NewBuildPage> createState() => _NewBuildPageState();
}

class _NewBuildPageState extends State<NewBuildPage> {
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCustomerName != null) {
      _titleController.text = '${widget.initialCustomerName}\'s Build';
    }
  }

  final List<_Part> _gpuList = _partsFromCategory(ComponentCategory.gpu);
  final List<_Part> _cpuList = _partsFromCategory(ComponentCategory.cpu);
  final List<_Part> _ramList = _partsFromCategory(ComponentCategory.ram);
  final List<_Part> _storageList = _partsFromCategory(ComponentCategory.storage);

  _Part? _selectedGpu;
  _Part? _selectedCpu;
  _Part? _selectedRam;
  _Part? _selectedStorage;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  double get _totalPrice =>
      (_selectedGpu?.price ?? 0) +
      (_selectedCpu?.price ?? 0) +
      (_selectedRam?.price ?? 0) +
      (_selectedStorage?.price ?? 0);

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _selectedGpu != null &&
      _selectedCpu != null &&
      _selectedRam != null &&
      _selectedStorage != null;

  Future<void> _submit() async {
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Text('Please fill in all fields',
            style: TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
      ));
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final newBuild = RecentBuildModel(
      id: 'BLD-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _titleController.text.trim(),
      specs: '${_selectedGpu!.name.split(' ').take(2).join(' ')} + '
          '${_selectedCpu!.name.split(' ').take(2).join(' ')}',
      gpu: _selectedGpu!.name,
      cpu: _selectedCpu!.name,
      estimatedPrice: _totalPrice,
      createdAt: DateTime.now(),
    );

    setState(() => _isSubmitting = false);
    widget.onBuildCreated?.call(newBuild);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text('Build #${newBuild.id} created!',
              style: const TextStyle(color: Colors.white)),
        ]),
        duration: const Duration(seconds: 2),
      ));
      Navigator.pop(context, newBuild);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('New PC Build', style: AppTextStyles.headingSmall),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Build Title ──────────────────────────
                  _SectionLabel(label: 'Build Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    onChanged: (_) => setState(() {}),
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. Gaming PC Build',
                      hintStyle: AppTextStyles.bodyMedium,
                      prefixIcon: const Icon(Icons.computer_outlined,
                          size: 18, color: AppColors.textMuted),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── GPU ──────────────────────────────────
                  _PartSelector(
                    label: 'Graphics Card (GPU)',
                    icon: Icons.memory_outlined,
                    parts: _gpuList,
                    selected: _selectedGpu,
                    onSelected: (p) => setState(() => _selectedGpu = p),
                  ),

                  const SizedBox(height: 16),

                  // ── CPU ──────────────────────────────────
                  _PartSelector(
                    label: 'Processor (CPU)',
                    icon: Icons.developer_board_outlined,
                    parts: _cpuList,
                    selected: _selectedCpu,
                    onSelected: (p) => setState(() => _selectedCpu = p),
                  ),

                  const SizedBox(height: 16),

                  // ── RAM ──────────────────────────────────
                  _PartSelector(
                    label: 'Memory (RAM)',
                    icon: Icons.storage_outlined,
                    parts: _ramList,
                    selected: _selectedRam,
                    onSelected: (p) => setState(() => _selectedRam = p),
                  ),

                  const SizedBox(height: 16),

                  // ── Storage ──────────────────────────────
                  _PartSelector(
                    label: 'Storage',
                    icon: Icons.save_outlined,
                    parts: _storageList,
                    selected: _selectedStorage,
                    onSelected: (p) => setState(() => _selectedStorage = p),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // ── Sticky Bottom Bar ──────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 14, 20,
                MediaQuery.of(context).padding.bottom + 14),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Estimated Total',
                        style: AppTextStyles.label),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(0)}',
                      style: AppTextStyles.headingMedium.copyWith(
                          color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSubmit
                          ? AppColors.primary
                          : AppColors.primaryBorder,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Create Build',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )),
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

// ── Part selector widget ──────────────────────────────────────────────────────

class _PartSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<_Part> parts;
  final _Part? selected;
  final void Function(_Part) onSelected;

  const _PartSelector({
    required this.label,
    required this.icon,
    required this.parts,
    required this.selected,
    required this.onSelected,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(label, style: AppTextStyles.headingSmall),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.border),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                itemCount: parts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final p = parts[i];
                  final isSelected = selected?.name == p.name;
                  return GestureDetector(
                    onTap: () {
                      onSelected(p);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primarySoft
                            : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name,
                                  style: AppTextStyles.headingSmall
                                      .copyWith(fontSize: 14,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(p.detail,
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('\$${p.price.toStringAsFixed(0)}',
                            style: AppTextStyles.headingSmall.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 14,
                            )),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle_rounded,
                                size: 18, color: AppColors.primary),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected != null
                    ? AppColors.primary
                    : AppColors.border,
                width: selected != null ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: selected != null
                        ? AppColors.primarySoft
                        : AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      size: 16,
                      color: selected != null
                          ? AppColors.primary
                          : AppColors.textMuted),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: selected != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selected!.name,
                              style: AppTextStyles.headingSmall.copyWith(
                                  fontSize: 14, color: AppColors.primary)),
                            Text(selected!.detail,
                                style: AppTextStyles.bodySmall),
                          ],
                        )
                      : Text('Select ${label.split(' ').first}...',
                          style: AppTextStyles.bodyMedium),
                ),
                if (selected != null)
                  Text('\$${selected!.price.toStringAsFixed(0)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(width: 6),
                Icon(
                  selected != null
                      ? Icons.check_circle_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: selected != null
                      ? AppColors.primary
                      : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: AppTextStyles.headingSmall.copyWith(fontSize: 13));
  }
}