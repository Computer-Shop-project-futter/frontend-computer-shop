// lib/core/widgets/connectivity_status.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/data/products_repository_hybrid.dart';

final connectivityProvider = Provider<bool>((ref) {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.isOnline;
});

class ConnectivityStatusWidget extends ConsumerWidget {
  const ConnectivityStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);
    
    if (isOnline) return const SizedBox.shrink();
    
    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            'You are offline. Using cached data.',
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}