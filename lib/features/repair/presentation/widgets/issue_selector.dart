// lib/features/repair/presentation/widgets/issue_selector.dart

import 'package:flutter/material.dart';
import '../../data/repair_repository.dart';

class IssueSelector extends StatelessWidget {
  final List<String> selectedIssues;
  final Function(String) onIssueToggled;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const IssueSelector({
    super.key,
    required this.selectedIssues,
    required this.onIssueToggled,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (final issue in RepairRepository.availableIssues) {
      if (selectedIssues.contains(issue.id)) {
        totalPrice += issue.basePrice;
      }
    }
    if (selectedIssues.length > 1) {
      totalPrice = totalPrice * 0.9;
    }

    return Column(
      children: [
        const Text(
          'SELECT ISSUES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Color(0xFF10213B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all that apply',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7891),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: RepairRepository.availableIssues.length,
          itemBuilder: (context, index) {
            final issue = RepairRepository.availableIssues[index];
            final isSelected = selectedIssues.contains(issue.id);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => onIssueToggled(issue.id),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEAF1FF) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF2A66FF) : const Color(0xFFE3E9F5),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2A66FF).withOpacity(0.1) : const Color(0xFFF0F2F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          issue.icon,
                          color: isSelected ? const Color(0xFF2A66FF) : const Color(0xFF6B7891),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF10213B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              issue.description,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B7891),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${issue.basePrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2A66FF),
                            ),
                          ),
                          Text(
                            '~${issue.estimatedTime.inHours}h',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF6B7891),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? const Color(0xFF2A66FF) : const Color(0xFFB3BDD1),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        if (selectedIssues.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Estimated Total:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10213B),
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2A66FF),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2A66FF)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('BACK'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A66FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('CONTINUE'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}