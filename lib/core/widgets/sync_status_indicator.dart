// lib/core/widgets/sync_status_indicator.dart

import 'package:flutter/material.dart';
import '../services/offline_sync_service.dart';

class SyncStatusIndicator extends StatefulWidget {
  final bool showText;
  final VoidCallback? onTap;

  const SyncStatusIndicator({
    super.key,
    this.showText = true,
    this.onTap,
  });

  @override
  State<SyncStatusIndicator> createState() => _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends State<SyncStatusIndicator> {
  final OfflineSyncService _syncService = OfflineSyncService();

  @override
  void initState() {
    super.initState();
    _syncService.syncStatusStream.listen((status) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncStatus>(
      stream: _syncService.syncStatusStream,
      builder: (context, snapshot) {
        final status = snapshot.data;
        
        if (status == null) {
          return const SizedBox.shrink();
        }
        
        if (status.isOffline) {
          return _buildIndicator(
            icon: Icons.wifi_off_rounded,
            color: Colors.orange,
            text: 'Offline',
          );
        }
        
        if (status.isProgress) {
          return _buildIndicator(
            icon: Icons.sync_rounded,
            color: Colors.blue,
            text: 'Syncing... ${(status.progressPercent * 100).toInt()}%',
            isAnimated: true,
          );
        }
        
        if (status.isStarted) {
          return _buildIndicator(
            icon: Icons.sync_rounded,
            color: Colors.blue,
            text: 'Starting sync...',
            isAnimated: true,
          );
        }
        
        if (status.isCompleted && status.successCount! > 0) {
          return _buildIndicator(
            icon: Icons.check_circle_rounded,
            color: Colors.green,
            text: 'Synced',
          );
        }
        
        if (status.isFailed) {
          return _buildIndicator(
            icon: Icons.error_rounded,
            color: Colors.red,
            text: 'Sync failed',
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required Color color,
    required String text,
    bool isAnimated = false,
  }) {
    return GestureDetector(
      onTap: widget.onTap ?? () {
        if (color == Colors.red) {
          OfflineSyncService().forceSync();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAnimated)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, size: 16, color: color),
            if (widget.showText) ...[
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(fontSize: 11, color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}