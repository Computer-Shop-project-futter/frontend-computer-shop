// ─────────────────────────────────────────────
//  G14 Admin — Feedback Screen
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../data/app_theme.dart';
import '../../models/models.dart';

class FeedbackScreen extends StatefulWidget {
  final VoidCallback onMenuTap;
  const FeedbackScreen({super.key, required this.onMenuTap});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late List<FeedbackItem> _items;
  FeedbackStatus? _filter; // null = all

  @override
  void initState() {
    super.initState();
    _items = FeedbackData.seed;
  }

  List<FeedbackItem> get _filtered {
    if (_filter == null) return _items;
    return _items.where((f) => f.status == _filter).toList();
  }

  void _setStatus(FeedbackItem item, FeedbackStatus status) {
    setState(() {
      final idx = _items.indexWhere((f) => f.id == item.id);
      if (idx >= 0) _items[idx] = item.copyWith(status: status);
    });
  }

  void _openReplySheet(FeedbackItem item) {
    final replyCtrl = TextEditingController(text: item.adminReply ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: C.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text('Reply to ${item.customerName}',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: C.textPrimary)),
              const SizedBox(height: 14),
              TextField(
                controller: replyCtrl,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: C.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Write a response…',
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.accent, width: 1.5)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final idx = _items.indexWhere((f) => f.id == item.id);
                      if (idx >= 0) {
                        _items[idx] = item.copyWith(
                          adminReply: replyCtrl.text.trim().isEmpty ? null : replyCtrl.text.trim(),
                          status: FeedbackStatus.resolved,
                        );
                      }
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Reply sent', style: TextStyle(fontWeight: FontWeight.w600)),
                      backgroundColor: C.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(16),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Send Reply', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(onMenuTap: widget.onMenuTap),
            _SummaryRow(items: _items),
            _FilterTabs(
              selected: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('No feedback in this category', style: TextStyle(color: C.textMuted)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => FeedbackCard(
                        item: filtered[i],
                        onMarkReviewed: () => _setStatus(filtered[i], FeedbackStatus.inReview),
                        onReply: () => _openReplySheet(filtered[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final List<FeedbackItem> items;
  const _SummaryRow({required this.items});

  @override
  Widget build(BuildContext context) {
    final avgRating = items.isEmpty
        ? 0.0
        : items.fold<int>(0, (sum, f) => sum + f.rating) / items.length;
    final newCount = items.where((f) => f.status == FeedbackStatus.newFeedback).length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFF59E0B),
              label: 'Avg. Rating',
              value: avgRating.toStringAsFixed(1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatTile(
              icon: Icons.mark_email_unread_outlined,
              iconColor: C.accent,
              label: 'New',
              value: '$newCount',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatTile(
              icon: Icons.forum_outlined,
              iconColor: C.green,
              label: 'Total',
              value: '${items.length}',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatTile({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: C.textPrimary)),
          Text(label, style: const TextStyle(fontSize: 10, color: C.textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final FeedbackStatus? selected;
  final ValueChanged<FeedbackStatus?> onChanged;

  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _Tab(label: 'All', isSelected: selected == null, onTap: () => onChanged(null)),
            const SizedBox(width: 8),
            ...FeedbackStatus.values.map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _Tab(label: s.label, isSelected: selected == s, color: s.color, onTap: () => onChanged(s)),
                )),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.isSelected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final tabColor = color ?? C.accent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? tabColor : const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: isSelected ? tabColor : C.border),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : C.textSecondary)),
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final FeedbackItem item;
  final VoidCallback onMarkReviewed;
  final VoidCallback onReply;

  const FeedbackCard({
    super.key,
    required this.item,
    required this.onMarkReviewed,
    required this.onReply,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border),
        boxShadow: const [BoxShadow(color: Color(0x09000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: C.accent.withOpacity(0.12),
                child: Text(
                  item.customerName.isNotEmpty ? item.customerName[0].toUpperCase() : '?',
                  style: const TextStyle(color: C.accent, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.customerName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.textPrimary)),
                    Text(item.customerEmail, style: const TextStyle(fontSize: 11.5, color: C.textMuted)),
                  ],
                ),
              ),
              _StatusChip(status: item.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) => Icon(
                  i < item.rating ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 16,
                  color: const Color(0xFFF59E0B),
                )),
          ),
          const SizedBox(height: 8),
          Text(item.message, style: const TextStyle(fontSize: 13, color: C.textSecondary, height: 1.4)),
          const SizedBox(height: 8),
          Text(_timeAgo(item.submittedAt), style: const TextStyle(fontSize: 11, color: C.textMuted)),

          if (item.adminReply != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YOUR REPLY',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: C.accent, letterSpacing: 0.6)),
                  const SizedBox(height: 4),
                  Text(item.adminReply!, style: const TextStyle(fontSize: 12.5, color: C.textPrimary, height: 1.4)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              if (item.status == FeedbackStatus.newFeedback)
                TextButton(
                  onPressed: onMarkReviewed,
                  style: TextButton.styleFrom(foregroundColor: C.textSecondary),
                  child: const Text('Mark In Review', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply_rounded, size: 15),
                label: Text(item.adminReply != null ? 'Edit Reply' : 'Reply',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: C.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final FeedbackStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status.label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: status.color)),
    );
  }
}

// ── App bar ────────────────────────────────────
class _AppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _AppBar({required this.onMenuTap});

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
          if (MediaQuery.of(context).size.width < 900)
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
                Text('Feedback', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: C.textPrimary, letterSpacing: -0.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
