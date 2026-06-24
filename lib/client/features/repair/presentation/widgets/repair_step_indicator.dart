// lib/features/repair/presentation/widgets/repair_step_indicator.dart

import 'package:flutter/material.dart';

class RepairStepIndicator extends StatelessWidget {
  final int currentStep;

  const RepairStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Device', 'Issues', 'Details'];

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index <= currentStep;
        final isCompleted = index < currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isActive
                          ? const Color(0xFF2A66FF)
                          : const Color(0xFFE3E9F5),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? const Color(0xFF2A66FF)
                          : const Color(0xFFE3E9F5),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isActive ? Colors.white : const Color(0xFF6B7891),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == steps.length - 1
                          ? Colors.transparent
                          : isActive
                              ? const Color(0xFF2A66FF)
                              : const Color(0xFFE3E9F5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? const Color(0xFF2A66FF) : const Color(0xFF6B7891),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}