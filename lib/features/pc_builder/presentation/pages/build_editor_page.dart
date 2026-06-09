// lib/features/builder/presentation/pages/build_editor_page.dart

import 'package:computer_shop/features/pc_builder/domain/builder_model.dart';
import 'package:computer_shop/features/shared/header/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/builder_provider.dart';
import '../widgets/component_selector.dart';

class BuildEditorPage extends ConsumerStatefulWidget {
  const BuildEditorPage({super.key});

  @override
  ConsumerState<BuildEditorPage> createState() => _BuildEditorPageState();
}

class _BuildEditorPageState extends ConsumerState<BuildEditorPage> {
  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(builderProvider);
    final build = builderState.currentBuild;
    final notifier = ref.read(builderProvider.notifier);

    if (build == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If selecting a component, show the selector
    if (builderState.selectingComponentType != null) {
      return ComponentSelector(
        componentType: builderState.selectingComponentType!,
        onSelect: (component) {
          notifier.selectComponent(component);
        },
        onClose: () {
          notifier.clearComponentSelection();
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          AppHeaderBar(
            dark: true,
            child: Row(
              children: [
                AppHeaderIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => context.pop(),
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/images/g14_logo.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                const Text(
                  'G14-TECH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),
                AppHeaderIconButton(
                  icon: Icons.save_rounded,
                  onTap: () async {
                    await notifier.saveCurrentBuild();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Build saved!'),
                          backgroundColor: Color(0xFF2A66FF),
                        ),
                      );
                      context.pop();
                    }
                  },
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Build Name
                  _BuildNameField(
                    initialName: build.name,
                    onChanged: notifier.updateBuildName,
                  ),
                  const SizedBox(height: 20),

                  // Components Grid
                  const Text(
                    'PRECISION ENGINEERING SYSTEM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Color(0xFF6B7891),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    build.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF10213B),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Component Cards
                  _ComponentCard(
                    label: 'CPU',
                    component: build.cpu,
                    onTap: () => notifier.startComponentSelection(ComponentType.cpu),
                  ),
                  const SizedBox(height: 12),

                  _ComponentCard(
                    label: 'GPU',
                    component: build.gpu,
                    onTap: () => notifier.startComponentSelection(ComponentType.gpu),
                  ),
                  const SizedBox(height: 12),

                  _ComponentCard(
                    label: 'Motherboard',
                    component: build.motherboard,
                    onTap: () => notifier.startComponentSelection(ComponentType.motherboard),
                    isTapToConfigure: true,
                  ),
                  const SizedBox(height: 12),

                  _ComponentCard(
                    label: 'RAM',
                    component: build.ram,
                    onTap: () => notifier.startComponentSelection(ComponentType.ram),
                    isTapToConfigure: true,
                  ),
                  const SizedBox(height: 12),

                  _ComponentCard(
                    label: 'Storage',
                    component: build.storage,
                    onTap: () => notifier.startComponentSelection(ComponentType.storage),
                  ),
                  const SizedBox(height: 20),

                  // System Note (Compatibility Warning)
                  if (_hasCompatibilityWarning(build))
                    _SystemNote(
                      message: 'Selected motherboard may require a BIOS update for this CPU. '
                          'Ensure you have a compatible flash drive or an older processor for the update process.',
                    ),
                  const SizedBox(height: 20),

                  // Engineering Standards Section
                  const _EngineeringStandards(),
                  const SizedBox(height: 24),

                  // Bottom Bar with Total and Add to Cart
                  _BottomBar(
                    total: build.totalPrice,
                    onAddToCart: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Build added to cart!'),
                          backgroundColor: Color(0xFF2A66FF),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasCompatibilityWarning(BuildConfiguration build) {
    // Check if motherboard is missing but CPU is selected
    return build.cpu != null && build.motherboard == null;
  }
}

// lib/features/pc_builder/presentation/pages/build_editor_page.dart

class _BuildNameField extends StatelessWidget {
  final String initialName;
  final ValueChanged<String> onChanged;

  const _BuildNameField({
    required this.initialName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialName);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E9F5)),
      ),
      child: TextField(
        controller: controller,  // Use controller instead of initialValue
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF10213B),
        ),
        decoration: const InputDecoration(
          hintText: 'Build Name',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.edit_outlined, size: 20, color: Color(0xFF6B7891)),
        ),
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final String label;
  final Component? component;
  final VoidCallback onTap;
  final bool isTapToConfigure;

  const _ComponentCard({
    required this.label,
    required this.component,
    required this.onTap,
    this.isTapToConfigure = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E9F5)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getComponentIcon(label),
                color: const Color(0xFF2A66FF),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: Color(0xFF6B7891),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    component != null
                        ? '${component!.name}\n\$${component!.price.toStringAsFixed(2)}'
                        : (isTapToConfigure ? 'Tap to configure' : 'Tap to select'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: component != null ? FontWeight.w800 : FontWeight.w500,
                      color: component != null ? const Color(0xFF10213B) : const Color(0xFF6B7891),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              component != null ? Icons.check_circle : Icons.chevron_right,
              color: component != null ? const Color(0xFF2A66FF) : const Color(0xFFB3BDD1),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getComponentIcon(String label) {
    switch (label) {
      case 'CPU': return Icons.memory;
      case 'GPU': return Icons.developer_board;
      case 'Motherboard': return Icons.cable;
      case 'RAM': return Icons.sd_storage;
      case 'Storage': return Icons.storage;
      default: return Icons.computer;
    }
  }
}

class _SystemNote extends StatelessWidget {
  final String message;

  const _SystemNote({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE5B4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF92400E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EngineeringStandards extends StatelessWidget {
  const _EngineeringStandards();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3470), Color(0xFF0B1530)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ENGINEERING STANDARDS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF8FB4FF),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '# Advanced Thermal Management',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Optimized airflow paths and premium thermal compounds ensure peak performance under load.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final double total;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.total,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURRENT CONFIG',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: Color(0xFF6B7891),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2A66FF),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A66FF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}