import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/recent_repair_model.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/recent_repair_card.dart';
import 'repair_detail_page.dart';

class AllRepairsPage extends StatefulWidget {
  final DashboardProvider provider;

  const AllRepairsPage({super.key, required this.provider});

  @override
  State<AllRepairsPage> createState() => _AllRepairsPageState();
}

class _AllRepairsPageState extends State<AllRepairsPage> {
  late final DashboardProvider _provider;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = widget.provider;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<RecentRepairModel> get _filteredRepairs {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return _provider.repairs;
    return _provider.repairs.where((r) {
      return r.id.toLowerCase().contains(q) ||
          r.title.toLowerCase().contains(q) ||
          r.customerName.toLowerCase().contains(q) ||
          r.device.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final repairs = _filteredRepairs;

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
        title: Text('All Repairs', style: AppTextStyles.headingSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${repairs.length} repairs',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search repairs...',
                hintStyle: AppTextStyles.bodyMedium,
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 20, color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: AppColors.textMuted),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceSecondary,
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
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Repair List ─────────────────────────────────────
          Expanded(
            child: repairs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.build_outlined,
                            size: 54,
                            color: AppColors.textMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 14),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No repairs found'
                              : 'No repairs yet',
                          style: AppTextStyles.headingSmall
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: repairs.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RecentRepairCard(
                        repair: repairs[i],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RepairDetailPage(
                                repair: repairs[i],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}