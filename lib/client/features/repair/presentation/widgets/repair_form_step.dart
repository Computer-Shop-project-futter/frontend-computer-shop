// lib/features/repair/presentation/widgets/repair_form_step.dart

import 'package:flutter/material.dart';
import '../../data/repair_repository.dart';

class RepairFormStep extends StatelessWidget {
  final String deviceModel;
  final String description;
  final List<String> selectedIssues;
  final Function(String) onModelChanged;
  final Function(String) onDescriptionChanged;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final bool isLoading;

  const RepairFormStep({
    super.key,
    required this.deviceModel,
    required this.description,
    required this.selectedIssues,
    required this.onModelChanged,
    required this.onDescriptionChanged,
    required this.onSubmit,
    required this.onBack,
    required this.isLoading,
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
          'DEVICE DETAILS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Color(0xFF10213B),
          ),
        ),
        const SizedBox(height: 16),
        
        // Device Model
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3E9F5)),
          ),
          child: TextField(
            onChanged: onModelChanged,
            decoration: const InputDecoration(
              labelText: 'Device Model',
              hintText: 'e.g., NovaBook Pro 16, Apex Gaming Rig',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Description
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3E9F5)),
          ),
          child: TextField(
            onChanged: onDescriptionChanged,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Issue Description',
              hintText: 'Describe the problem in detail...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              alignLabelWithHint: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_long, size: 20, color: Color(0xFF2A66FF)),
                  SizedBox(width: 8),
                  Text(
                    'REPAIR SUMMARY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2A66FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final issueId in selectedIssues)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          RepairRepository.availableIssues.firstWhere((i) => i.id == issueId).name,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF10213B)),
                        ),
                      ),
                      Text(
                        '\$${RepairRepository.availableIssues.firstWhere((i) => i.id == issueId).basePrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Estimate:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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
              const SizedBox(height: 8),
              const Text(
                '* Final price may vary after diagnosis',
                style: TextStyle(fontSize: 10, color: Color(0xFF6B7891)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Action Buttons
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
                onPressed: isLoading ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A66FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('SUBMIT REQUEST'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}