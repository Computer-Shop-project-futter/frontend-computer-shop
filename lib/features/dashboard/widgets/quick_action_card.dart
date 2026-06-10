import 'package:flutter/material.dart';
import '../app_theme.dart';

class QuickActionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final Color? bgColor;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.label,
    required this.icon,
    this.color,
    this.bgColor,
    this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColor = widget.color ?? AppColors.primary;
    final resolvedBg = widget.bgColor ?? AppColors.primarySoft;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: resolvedBg,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(widget.icon, size: 22, color: resolvedColor),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Convenience row of quick actions ─────────────────────────────────────────

class QuickActionsRow extends StatelessWidget {
  final Function(String action)? onAction;

  const QuickActionsRow({super.key, this.onAction});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action('Build PC', Icons.computer_outlined, AppColors.primary,
          AppColors.primarySoft, 'build_pc'),
      _Action('Add Repair', Icons.build_outlined, AppColors.warning,
          AppColors.warningSoft, 'add_repair'),
      _Action('Open Chat', Icons.chat_bubble_outline_rounded, AppColors.success,
          AppColors.successSoft, 'open_chat'),
      _Action('Customers', Icons.people_outline_rounded, AppColors.primaryLight,
          AppColors.primarySoft, 'customers'),
    ];

    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: actions.last == a ? 0 : 10,
                ),
                child: SizedBox(
                  height: 88,
                  child: QuickActionCard(
                    label: a.label,
                    icon: a.icon,
                    color: a.color,
                    bgColor: a.bgColor,
                    onTap: () => onAction?.call(a.key),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String key;
  const _Action(this.label, this.icon, this.color, this.bgColor, this.key);
}