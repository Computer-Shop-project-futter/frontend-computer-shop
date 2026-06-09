// lib/features/repair/presentation/pages/repair_page.dart

import 'package:computer_shop/features/repair/domain/repair_model.dart';
import 'package:computer_shop/features/shared/footer/app_footer.dart';
import 'package:computer_shop/features/shared/header/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/repair_provider.dart';
import '../widgets/repair_step_indicator.dart';
import '../widgets/device_type_selector.dart';
import '../widgets/issue_selector.dart';
import '../widgets/repair_form_step.dart';
import '../widgets/repair_history_card.dart';

class RepairPage extends ConsumerStatefulWidget {
  const RepairPage({super.key});

  @override
  ConsumerState<RepairPage> createState() => _RepairPageState();
}

class _RepairPageState extends ConsumerState<RepairPage> {
  @override
  Widget build(BuildContext context) {
    final repairState = ref.watch(repairProvider);
    final notifier = ref.read(repairProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          // Header
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
                  icon: Icons.history_rounded,
                  onTap: () {
                    _showRepairHistory(context, repairState.repairHistory);
                  },
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: repairState.isLoading && repairState.step == 0
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      children: [
                        // Hero Banner
                        const _RepairHeroBanner(),
                        const SizedBox(height: 20),

                        // Step Indicator
                        RepairStepIndicator(currentStep: repairState.step),
                        const SizedBox(height: 24),

                        // Error Message
                        if (repairState.error != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    repairState.error!,
                                    style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: notifier.clearError,
                                  child: const Icon(Icons.close, size: 16, color: Color(0xFFEF4444)),
                                ),
                              ],
                            ),
                          ),

                        // Step Content
                        _buildStepContent(repairState, notifier),
                      ],
                    ),
                  ),
          ),

          // Bottom Navigation
          AppNavigationFooter(
            currentIndex: 4, // Repair tab index (matches AppNavigationFooter destinations)
            onTabSelected: (index) {
              if (index == 0) {
                context.go('/home');
              } else if (index == 1) context.go('/products');
              else if (index == 2) context.go('/wishlist');
              else if (index == 3) context.go('/builder');
              else if (index == 4) context.go('/repair');
              else if (index == 5) context.go('/account');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(RepairState state, RepairNotifier notifier) {
    switch (state.step) {
      case 0:
        return DeviceTypeSelector(
          selectedType: state.selectedDeviceType,
          onTypeSelected: notifier.setDeviceType,
          onNext: () {
            if (state.selectedDeviceType != null) {
              notifier.nextStep();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a device type'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
            }
          },
        );
      case 1:
        return IssueSelector(
          selectedIssues: state.selectedIssues,
          onIssueToggled: notifier.toggleIssue,
          onNext: () {
            if (state.selectedIssues.isNotEmpty) {
              notifier.nextStep();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select at least one issue'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
            }
          },
          onBack: notifier.previousStep,
        );
      case 2:
        return RepairFormStep(
          deviceModel: state.deviceModel,
          description: state.description,
          selectedIssues: state.selectedIssues,
          onModelChanged: notifier.setDeviceModel,
          onDescriptionChanged: notifier.setDescription,
          onSubmit: notifier.submitRepair,
          onBack: notifier.previousStep,
          isLoading: state.isLoading,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showRepairHistory(BuildContext context, List<RepairRequest> history) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E9F5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'REPAIR HISTORY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10213B),
                  ),
                ),
              ),
              Expanded(
                child: history.isEmpty
                    ? const Center(
                        child: Text('No repair history yet'),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return RepairHistoryCard(
                            repair: history[index],
                            onCancel: () {
                              ref.read(repairProvider.notifier).cancelRepair(history[index].id);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hero Banner
class _RepairHeroBanner extends StatelessWidget {
  const _RepairHeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF12306A), Color(0xFF0D1C3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A66FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'EXPERT REPAIR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Professional\nDevice Repair',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fast, reliable service with warranty',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.build_circle_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}