import 'package:flutter/material.dart';
import '../models/recent_build_model.dart';
import '../app_theme.dart';

// ── Static parts catalogue — replace with API later ──────────────────────────

class _Part {
  final String name;
  final String detail;
  final double price;
  const _Part(this.name, this.detail, this.price);
}

const _gpuList = [
  _Part('RTX 4090', '24 GB GDDR6X • 450W', 1599),
  _Part('RTX 4080 Super', '16 GB GDDR6X • 320W', 999),
  _Part('RTX 4070', '12 GB GDDR6X • 200W', 599),
  _Part('RX 7900 XTX', '24 GB GDDR6 • 355W', 949),
  _Part('RX 6600', '8 GB GDDR6 • 132W', 239),
  _Part('RTX 3060', '12 GB GDDR6 • 170W', 299),
];

const _cpuList = [
  _Part('Intel i9-13900K', '24 Cores • 5.8 GHz Boost', 549),
  _Part('Intel i7-13700K', '16 Cores • 5.4 GHz Boost', 349),
  _Part('Ryzen 9 7950X', '16 Cores • 5.7 GHz Boost', 699),
  _Part('Ryzen 7 7800X3D', '8 Cores • 5.0 GHz Boost', 449),
  _Part('Ryzen 7 5800X', '8 Cores • 4.7 GHz Boost', 249),
  _Part('Ryzen 5 5600X', '6 Cores • 4.6 GHz Boost', 149),
];

const _ramList = [
  _Part('64 GB DDR5 6000', 'Corsair Vengeance • 2×32 GB', 189),
  _Part('32 GB DDR5 5200', 'G.Skill Trident Z5 • 2×16 GB', 99),
  _Part('32 GB DDR4 3600', 'Corsair Vengeance • 2×16 GB', 69),
  _Part('16 GB DDR5 5200', 'Kingston Fury Beast • 2×8 GB', 59),
  _Part('16 GB DDR4 3200', 'Crucial Ballistix • 2×8 GB', 39),
];

const _storageList = [
  _Part('2 TB NVMe SSD', 'Samsung 990 Pro • 7450 MB/s', 189),
  _Part('1 TB NVMe SSD', 'WD Black SN850X • 7300 MB/s', 99),
  _Part('1 TB SATA SSD', 'Samsung 870 EVO • 560 MB/s', 79),
  _Part('2 TB HDD', 'Seagate Barracuda • 7200 RPM', 55),
  _Part('500 GB NVMe SSD', 'Crucial P3 Plus • 5000 MB/s', 49),
];

// ── Page ──────────────────────────────────────────────────────────────────────

class NewBuildPage extends StatefulWidget {
  final void Function(RecentBuildModel build)? onBuildCreated;

  const NewBuildPage({super.key, this.onBuildCreated});

  @override
  State<NewBuildPage> createState() => _NewBuildPageState();
}

class _NewBuildPageState extends State<NewBuildPage> {
  final _titleController = TextEditingController();

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