<<<<<<< HEAD
import 'package:flutter/material.dart';
import '../app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String staffName;
  final String branchName;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const DashboardHeader({
    super.key,
    this.staffName = 'Alex Rivers',
    this.branchName = 'Downtown Flagship',
    this.notificationCount = 3,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  String get _initials {
    final parts = staffName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return staffName.isNotEmpty ? staffName[0] : 'S';
  }

=======
import 'dart:convert';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/staff_profile_model.dart';

class DashboardHeader extends StatelessWidget {
  final int notificationCount;
  final int chatUnreadCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    this.notificationCount = 3,
    this.chatUnreadCount = 0,
    this.onNotificationTap,
    this.onChatTap,
    this.onMenuTap,
    this.onProfileTap,
  });

>>>>>>> 4bf4199 (update code in client and admin)
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
=======
    final profile = StaffProfileStore().profile;
    final hasAvatar = profile.avatarBase64 != null;

>>>>>>> 4bf4199 (update code in client and admin)
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
<<<<<<< HEAD
          // ── Avatar ──────────────────────────────────────
          GestureDetector(
            onTap: onAvatarTap,
=======
          // ── Hamburger Menu ──────────────────────────────────
          GestureDetector(
            onTap: onMenuTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // ── Avatar (tappable → Profile) ─────────────────────
          GestureDetector(
            onTap: onProfileTap,
>>>>>>> 4bf4199 (update code in client and admin)
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
<<<<<<< HEAD
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
=======
                gradient: hasAvatar
                    ? null
                    : const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
>>>>>>> 4bf4199 (update code in client and admin)
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
<<<<<<< HEAD
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ── Name & Branch ────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_greeting,',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  staffName,
                  style: AppTextStyles.headingSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      branchName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
=======
                image: hasAvatar
                    ? DecorationImage(
                        image: MemoryImage(
                          base64Decode(profile.avatarBase64!),
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: hasAvatar
                  ? null
                  : Center(
                      child: Text(
                        profile.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // ── Name & Branch & Staff ID (tappable → Profile) ──
          Expanded(
            child: GestureDetector(
              onTap: onProfileTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_greeting,',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      profile.name,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          profile.branch,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // ── Chat Icon ─────────────────────────────────────
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (chatUnreadCount > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            chatUnreadCount > 9
                                ? '9+'
                                : '$chatUnreadCount',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
>>>>>>> 4bf4199 (update code in client and admin)
          // ── Notification Bell ─────────────────────────────
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            notificationCount > 9
                                ? '9+'
                                : '$notificationCount',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}