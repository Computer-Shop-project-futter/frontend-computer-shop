// lib/features/repair/presentation/widgets/repair_history_card.dart

import 'package:computer_shop/features/repair/data/repair_repository.dart';
import 'package:flutter/material.dart';
import '../../domain/repair_model.dart';

class RepairHistoryCard extends StatelessWidget {
  final RepairRequest repair;
  final VoidCallback onCancel;

  const RepairHistoryCard({
    super.key,
    required this.repair,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final canCancel = repair.status == RepairStatus.pending ||
        repair.status == RepairStatus.diagnosed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E9F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                repair.orderNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10213B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: repair.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  repair.statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: repair.statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getDeviceTypeName(repair.deviceType),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7891),
            ),
          ),
          Text(
            repair.deviceModel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10213B),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: repair.issues.map((issueId) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getIssueName(issueId),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A66FF),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimated Price',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7891)),
                  ),
                  Text(
                    '\$${repair.estimatedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2A66FF),
                    ),
                  ),
                ],
              ),
              if (repair.scheduledDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Scheduled',
                      style: TextStyle(fontSize: 10, color: Color(0xFF6B7891)),
                    ),
                    Text(
                      _formatDate(repair.scheduledDate!),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10213B),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (repair.technicianName != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: Color(0xFF6B7891)),
                const SizedBox(width: 4),
                Text(
                  'Technician: ${repair.technicianName}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6B7891)),
                ),
              ],
            ),
          ],
          if (canCancel) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'CANCEL REQUEST',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getDeviceTypeName(DeviceType type) {
    switch (type) {
      case DeviceType.laptop: return 'Laptop';
      case DeviceType.desktop: return 'Desktop';
      case DeviceType.gamingPc: return 'Gaming PC';
      case DeviceType.workstation: return 'Workstation';
      case DeviceType.peripheral: return 'Peripheral';
    }
  }

  String _getIssueName(String issueId) {
    return RepairRepository.availableIssues.firstWhere((i) => i.id == issueId).name;
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}