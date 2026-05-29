import 'package:flutter/material.dart';
import '../app_theme.dart';

class ActivityOverviewCard extends StatelessWidget {
  final int openTickets;
  final int readyPickup;
  final int messages;
  final int dailyOrders;

  const ActivityOverviewCard({
    super.key,
    required this.openTickets,
    required this.readyPickup,
    required this.messages,
    required this.dailyOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.dashboard_outlined,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                'DASHBOARD OVERVIEW',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Operational Intel',
            style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(label: 'Open Tickets', value: '$openTickets'),
              _Divider(),
              _Stat(label: 'Ready Pickup', value: '$readyPickup'),
              _Divider(),
              _Stat(label: 'Messages', value: '$messages'),
              _Divider(),
              _Stat(label: 'Daily Orders', value: '$dailyOrders'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}