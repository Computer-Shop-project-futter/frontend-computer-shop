import 'package:flutter/material.dart';
import '../models/recent_repair_model.dart';
import '../app_theme.dart';

class _ActivityEntry {
  final String title;
  final String description;
  final String staffName;
  final DateTime time;
  final bool isLatest;

  const _ActivityEntry({
    required this.title,
    required this.description,
    required this.staffName,
    required this.time,
    this.isLatest = false,
  });
}

class RepairDetailPage extends StatefulWidget {
  final RecentRepairModel repair;

  const RepairDetailPage({super.key, required this.repair});

  @override
  State<RepairDetailPage> createState() => _RepairDetailPageState();
}

class _RepairDetailPageState extends State<RepairDetailPage> {
  late RepairStatus _currentStatus;
  final TextEditingController _logController = TextEditingController();

  late List<_ActivityEntry> _activityLog;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.repair.status;

    // Static activity log — replace with API data later
    _activityLog = [
      _ActivityEntry(
        title: 'INTAKE COMPLETED',
        description: 'Device received at downtown branch. External inspection passed.',
        staffName: 'Sarah Miller',
        time: widget.repair.date,
      ),
      _ActivityEntry(
        title: 'IN DIAGNOSIS',
        description: 'Running thermal stress tests. Fan assembly seems obstructed.',
        staffName: 'Marcus Chen',
        time: widget.repair.date.add(const Duration(hours: 2)),
        isLatest: true,
      ),
    ];
  }

  @override
  void dispose() {
    _logController.dispose();
    super.dispose();
  }

  void _logActivity() {
    final text = _logController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      // Mark previous latest as not latest
      _activityLog = _activityLog
          .map((e) => _ActivityEntry(
                title: e.title,
                description: e.description,
                staffName: e.staffName,
                time: e.time,
                isLatest: false,
              ))
          .toList();

      _activityLog.add(_ActivityEntry(
        title: 'NOTE ADDED',
        description: text,
        staffName: 'Alex Rivers',
        time: DateTime.now(),
        isLatest: true,
      ));
    });
    _logController.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(_snack('Activity logged'));
  }

  void _updateStatus(RepairStatus status) {
    setState(() {
      _currentStatus = status;
      _activityLog = _activityLog
          .map((e) => _ActivityEntry(
                title: e.title,
                description: e.description,
                staffName: e.staffName,
                time: e.time,
                isLatest: false,
              ))
          .toList();
      _activityLog.add(_ActivityEntry(
        title: 'STATUS UPDATED',
        description: 'Status changed to ${status.label}.',
        staffName: 'Alex Rivers',
        time: DateTime.now(),
        isLatest: true,
      ));
    });
    Navigator.pop(context); // close bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(_snack('Status updated to ${status.label}'));
  }

  SnackBar _snack(String msg) => SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13)),
        duration: const Duration(seconds: 2),
      );

  void _showStatusSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Update Status', style: AppTextStyles.headingMedium),
            const SizedBox(height: 16),
            ...RepairStatus.values.map((s) {
              final isSelected = s == _currentStatus;
              final color = AppColors.statusColor(s.label);
              final bg = AppColors.statusBg(s.label);
              return GestureDetector(
                onTap: () => _updateStatus(s),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? bg : AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Text(s.label, style: AppTextStyles.headingSmall.copyWith(
                        color: isSelected ? color : AppColors.textPrimary,
                      )),
                      const Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded, size: 18, color: color),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel = _currentStatus.label;
    final statusColor = AppColors.statusColor(statusLabel);
    final statusBg = AppColors.statusBg(statusLabel);

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
        title: Text('#${widget.repair.id}', style: AppTextStyles.headingSmall),
        actions: [
          TextButton(
            onPressed: _showStatusSheet,
            child: Text('Edit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
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

            // ── Status Banner ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white, fontSize: 11,
                        fontWeight: FontWeight.w700, letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_daysSince(widget.repair.date)} DAYS OPEN',
                    style: AppTextStyles.label,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Customer Info ──────────────────────────────
            _SectionCard(
              children: [
                _InfoRow(label: 'CUSTOMER NAME', value: widget.repair.customerName),
                _InfoRow(label: 'DEVICE', value: widget.repair.device),
                _InfoRow(label: 'ISSUE', value: widget.repair.title),
                _InfoRow(label: 'DROP-OFF DATE', value: _formatDate(widget.repair.date)),
                _InfoRow(label: 'BRANCH', value: 'Downtown', isLast: true),
              ],
            ),

            const SizedBox(height: 20),

            // ── Activity Log ───────────────────────────────
            const DashboardSectionTitleInline(title: 'Activity Log'),
            const SizedBox(height: 12),

            ..._activityLog.asMap().entries.map((entry) {
              final i = entry.key;
              final log = entry.value;
              final isLast = i == _activityLog.length - 1;
              return _ActivityRow(log: log, isLast: isLast);
            }),

            const SizedBox(height: 20),

            // ── Log New Activity ───────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Log New Activity', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _logController,
                    maxLines: 3,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Describe what was done...',
                      hintStyle: AppTextStyles.bodyMedium,
                      filled: true,
                      fillColor: AppColors.surfaceSecondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _showStatusSheet,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Update Status',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _logActivity,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: const Text('Log Activity',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  int _daysSince(DateTime date) => DateTime.now().difference(date).inDays;

  String _formatDate(DateTime d) => '${_month(d.month)} ${d.day}, ${d.year}';
  String _month(int m) => ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class DashboardSectionTitleInline extends StatelessWidget {
  final String title;
  const DashboardSectionTitleInline({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 18,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.headingSmall),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const _InfoRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Text(label, style: AppTextStyles.label),
              ),
              Expanded(
                child: Text(value,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final _ActivityEntry log;
  final bool isLast;
  const _ActivityRow({required this.log, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color: log.isLatest ? AppColors.primary : AppColors.primaryBorder,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                  boxShadow: log.isLatest ? [
                    BoxShadow(color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 6, offset: const Offset(0, 2))
                  ] : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.border),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.title,
                      style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(log.description,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(log.staffName, style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text(_fmt(log.time), style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final p = d.hour >= 12 ? 'PM' : 'AM';
    return '${_month(d.month)} ${d.day}, $h:$m $p';
  }

  String _month(int m) => ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}