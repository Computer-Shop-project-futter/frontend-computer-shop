// lib/features/repair/presentation/widgets/device_type_selector.dart

import 'package:flutter/material.dart';
import '../../domain/repair_model.dart';

class DeviceTypeSelector extends StatelessWidget {
  final DeviceType? selectedType;
  final Function(DeviceType) onTypeSelected;
  final VoidCallback onNext;

  const DeviceTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final deviceTypes = [
      {'type': DeviceType.laptop, 'icon': Icons.laptop, 'label': 'Laptop'},
      {'type': DeviceType.desktop, 'icon': Icons.computer, 'label': 'Desktop'},
      {'type': DeviceType.gamingPc, 'icon': Icons.sports_esports, 'label': 'Gaming PC'},
      {'type': DeviceType.workstation, 'icon': Icons.work, 'label': 'Workstation'},
      {'type': DeviceType.peripheral, 'icon': Icons.keyboard, 'label': 'Peripheral'},
    ];

    return Column(
      children: [
        const Text(
          'SELECT DEVICE TYPE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Color(0xFF10213B),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: deviceTypes.length,
          itemBuilder: (context, index) {
            final item = deviceTypes[index];
            final isSelected = selectedType == item['type'];
            return GestureDetector(
              onTap: () => onTypeSelected(item['type'] as DeviceType),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2A66FF) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2A66FF) : const Color(0xFFE3E9F5),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 40,
                      color: isSelected ? Colors.white : const Color(0xFF2A66FF),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : const Color(0xFF10213B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A66FF),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'CONTINUE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}