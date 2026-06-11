import 'package:flutter/material.dart';
import '../models/recent_build_model.dart';
import '../app_theme.dart';

class BuildDetailPage extends StatelessWidget {
  final RecentBuildModel pcBuild;

  const BuildDetailPage({super.key, required this.pcBuild});

  // Static part details — replace with API data later
  Map<String, List<Map<String, String>>> get _partCategories => {
    'Graphics Card (GPU)': [
      {'label': 'Model', 'value': pcBuild.gpu},
      {'label': 'VRAM', 'value': '12 GB GDDR6X'},
      {'label': 'TDP', 'value': '200W'},
    ],
    'Processor (CPU)': [
      {'label': 'Model', 'value': pcBuild.cpu},
      {'label': 'Cores', 'value': '8 Cores / 16 Threads'},
      {'label': 'Base Clock', 'value': '3.8 GHz'},
      {'label': 'Boost Clock', 'value': '4.7 GHz'},
    ],
    'Memory (RAM)': [
      {'label': 'Capacity', 'value': '32 GB'},
      {'label': 'Speed', 'value': 'DDR5 5200 MHz'},
      {'label': 'Slots Used', 'value': '2 x 16 GB'},
    ],
    'Storage': [
      {'label': 'Primary', 'value': '1 TB NVMe SSD'},
      {'label': 'Secondary', 'value': '2 TB HDD'},
      {'label': 'Read Speed', 'value': '7000 MB/s'},
    ],
    'Motherboard': [
      {'label': 'Model', 'value': 'ASUS ROG STRIX B650-E'},
      {'label': 'Socket', 'value': 'AM5'},
      {'label': 'Form Factor', 'value': 'ATX'},
    ],
    'Power Supply': [
      {'label': 'Wattage', 'value': '850W'},
      {'label': 'Efficiency', 'value': '80+ Gold'},
      {'label': 'Modular', 'value': 'Fully Modular'},
    ],
  };

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
        title: Text('#${pcBuild.id}', style: AppTextStyles.headingSmall),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Hero Banner ────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16, offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.computer_outlined,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pcBuild.title,
                          style: AppTextStyles.headingMedium
                              .copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(pcBuild.specs,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${pcBuild.estimatedPrice.toStringAsFixed(0)} estimated',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Parts Breakdown ────────────────────────────
            _SectionTitle(title: 'Parts Breakdown'),
            const SizedBox(height: 12),

            ..._partCategories.entries.map((entry) {
              final category = entry.key;
              final specs = entry.value;
              return _PartCard(category: category, specs: specs);
            }),

            const SizedBox(height: 24),

            // ── Price Summary ──────────────────────────────
            _SectionTitle(title: 'Price Summary'),
            const SizedBox(height: 12),
            _PriceSummary(total: pcBuild.estimatedPrice),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 18,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.headingSmall),
      ],
    );
  }
}

class _PartCard extends StatefulWidget {
  final String category;
  final List<Map<String, String>> specs;
  const _PartCard({required this.category, required this.specs});

  @override
  State<_PartCard> createState() => _PartCardState();
}

class _PartCardState extends State<_PartCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_categoryIcon(widget.category),
                        size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.category,
                          style: AppTextStyles.headingSmall.copyWith(fontSize: 13)),
                        Text(widget.specs.first['value'] ?? '',
                          style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20, color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Column(
                children: widget.specs.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(s['label'] ?? '',
                          style: AppTextStyles.label),
                      ),
                      Expanded(
                        child: Text(s['value'] ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    if (cat.contains('GPU')) return Icons.memory_outlined;
    if (cat.contains('CPU')) return Icons.developer_board_outlined;
    if (cat.contains('RAM')) return Icons.storage_outlined;
    if (cat.contains('Storage')) return Icons.save_outlined;
    if (cat.contains('Motherboard')) {
      return Icons.developer_board_outlined;
  }

    if (cat.contains('Power')) return Icons.bolt_outlined;
    return Icons.hardware_outlined;
  }
}

class _PriceSummary extends StatelessWidget {
  final double total;
  const _PriceSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    final parts = total * 0.78;
    final labor = total * 0.12;
    final tax = total * 0.10;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _PriceRow(label: 'Parts', value: parts),
          const SizedBox(height: 10),
          _PriceRow(label: 'Labor', value: labor),
          const SizedBox(height: 10),
          _PriceRow(label: 'Tax (10%)', value: tax),
          const SizedBox(height: 12),
          Divider(color: AppColors.border),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Total Estimate',
                style: AppTextStyles.headingSmall),
              const Spacer(),
              Text('\$${total.toStringAsFixed(0)}',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const Spacer(),
        Text('\$${value.toStringAsFixed(0)}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ],
    );
  }
}