import 'package:flutter/material.dart';
import '../models/dashboard_summary_model.dart';
import 'dashboard_card.dart';
import '../app_theme.dart';

class StatisticsGrid extends StatelessWidget {
  final DashboardSummaryModel summary;
  final Function(String route)? onCardTap;

  const StatisticsGrid({
    super.key,
    required this.summary,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        DashboardCard(
          label: 'Total Repairs',
          value: '${summary.totalRepairs}',
          icon: Icons.build_outlined,
          iconColor: AppColors.primary,
          iconBgColor: AppColors.primarySoft,
          trend: '+2%',
          trendUp: true,
          onTap: () => onCardTap?.call('/repairs'),
        ),
        DashboardCard(
          label: 'Pending Repairs',
          value: '${summary.pendingRepairs}',
          icon: Icons.hourglass_empty_rounded,
          iconColor: AppColors.warning,
          iconBgColor: AppColors.warningSoft,
          trend: '-1',
          trendUp: false,
          onTap: () => onCardTap?.call('/repairs?filter=pending'),
        ),
        DashboardCard(
          label: 'Active Chats',
          value: '${summary.activeChats}',
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: AppColors.success,
          iconBgColor: AppColors.successSoft,
          trend: '+3',
          trendUp: true,
          onTap: () => onCardTap?.call('/chats'),
        ),
        DashboardCard(
          label: 'Builds Today',
          value: '${summary.totalBuilds}',
          icon: Icons.computer_outlined,
          iconColor: AppColors.primaryLight,
          iconBgColor: AppColors.primarySoft,
          onTap: () => onCardTap?.call('/builds'),
        ),
      ],
    );
  }
}