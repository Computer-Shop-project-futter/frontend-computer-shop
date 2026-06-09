// lib/features/builder/presentation/pages/my_builds_page.dart

import 'package:computer_shop/features/pc_builder/domain/builder_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/builder_provider.dart';
import '../../../shared/header/app_header.dart';
import '../../../shared/footer/app_footer.dart';

class MyBuildsPage extends ConsumerWidget {
  const MyBuildsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builderState = ref.watch(builderProvider);
    final notifier = ref.read(builderProvider.notifier);

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
                  icon: Icons.add_rounded,
                  onTap: () {
                    notifier._createNewBuild();
                    context.go('/builder/edit');
                  },
                  backgroundColor: Colors.white.withOpacity(0.12),
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: builderState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : builderState.savedBuilds.isEmpty
                    ? _EmptyBuilds()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: builderState.savedBuilds.length,
                        itemBuilder: (context, index) {
                          final build = builderState.savedBuilds[index];
                          return _BuildCard(
                            buildConfiguration: build,
                            onEdit: () {
                              notifier.loadBuildForEdit(build);
                              context.go('/builder/edit');
                            },
                            onAddToCart: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Build added to cart'),
                                  backgroundColor: Color(0xFF2A66FF),
                                ),
                              );
                            },
                            onDelete: () {
                              _showDeleteDialog(context, notifier as WidgetRef, build.id);
                            },
                          );
                        },
                      ),
          ),
          
          AppNavigationFooter(
            currentIndex: 3, // Builder tab index
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String buildId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Build?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(builderProvider.notifier).deleteBuild(buildId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

extension on BuilderNotifier {
  void _createNewBuild() {}
}

class _BuildCard extends StatelessWidget {
  final BuildConfiguration buildConfiguration;
  final VoidCallback onEdit;
  final VoidCallback onAddToCart;
  final VoidCallback onDelete;

  const _BuildCard({
    required this.buildConfiguration,
    required this.onEdit,
    required this.onAddToCart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  buildConfiguration.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10213B),
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.more_vert, color: Color(0xFF6B7891)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(buildConfiguration.createdAt),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7891),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _getBuildDescription(buildConfiguration),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4D5A72),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\$${buildConfiguration.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2A66FF),
                  ),
                ),
              ),
              _ActionButton(
                label: 'EDIT',
                onPressed: onEdit,
                isPrimary: false,
              ),
              const SizedBox(width: 12),
              _ActionButton(
                label: 'ADD TO CART',
                onPressed: onAddToCart,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getBuildDescription(BuildConfiguration build) {
    final parts = <String>[];
    if (build.cpu != null) parts.add(build.cpu!.name);
    if (build.gpu != null) parts.add(build.gpu!.name);
    if (parts.isEmpty) return 'No components selected yet';
    return '${parts.take(2).join(' · ')}${parts.length > 2 ? ' +${parts.length - 2} more' : ''}';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BuildConfiguration>('buildConfiguration', buildConfiguration));
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A66FF),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
      );
    }
    
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF2A66FF)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF2A66FF)),
      ),
    );
  }
}

class _EmptyBuilds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.build_outlined, size: 50, color: Color(0xFF2A66FF)),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Builds Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF10213B)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start creating your first PC build',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7891)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/builder/edit'),
            icon: const Icon(Icons.add),
            label: const Text('START A NEW BUILD'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A66FF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}