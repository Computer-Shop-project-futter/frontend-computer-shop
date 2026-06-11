import 'package:flutter/material.dart';
import '../models/recent_chat_model.dart';
import '../app_theme.dart';

class RecentChatCard extends StatelessWidget {
  final RecentChatModel chat;
  final VoidCallback? onTap;

  const RecentChatCard({
    super.key,
    required this.chat,
    this.onTap,
  });

  // Cycle through avatar background colors for visual variety
  static const _avatarColors = [
    Color(0xFF1D4ED8), // blue
    Color(0xFF0EA5E9), // sky
    Color(0xFF8B5CF6), // violet
    Color(0xFF10B981), // emerald
    Color(0xFFF59E0B), // amber
  ];

  Color _avatarColor(String id) {
    final index = id.hashCode.abs() % _avatarColors.length;
    return _avatarColors[index];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: chat.isRead ? AppColors.white : AppColors.primarySoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: chat.isRead ? AppColors.border : AppColors.primaryBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _avatarColor(chat.id),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(
                      chat.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (chat.unreadCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${chat.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // ── Message Preview ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.customerName,
                    style: AppTextStyles.headingSmall.copyWith(
                      fontSize: 14,
                      fontWeight: chat.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '"${chat.lastMessage}"',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: chat.isRead
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // ── Timestamp + Arrow ─────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.timeAgo,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}