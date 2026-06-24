import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:computer_shop/client/features/chat/presentation/providers/staff_provider.dart';
import 'package:computer_shop/client/features/chat/domain/staff/staff_model.dart';
import 'package:computer_shop/client/core/constants/app_colors.dart';
import 'package:computer_shop/client/core/constants/app_text_styles.dart';

/// Staff selection page - like Facebook Messenger inbox
/// Shows available staff sorted by proximity with online status
class StaffListPage extends ConsumerStatefulWidget {
  const StaffListPage({super.key});

  @override
  ConsumerState<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends ConsumerState<StaffListPage> {
  @override
  void initState() {
    super.initState();
    // Load staff on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffListProvider.notifier).loadStaff();
    });
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffListProvider);

    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: _buildAppBar(),
      body: _buildBody(staffState),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.kBackground,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppColors.kPrimaryText,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Support Chat',
        style: AppTextStyles.headingSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        // Refresh button
        IconButton(
          icon: const Icon(Icons.refresh),
          color: AppColors.kSecondaryText,
          tooltip: 'Refresh staff list',
          onPressed: () => ref.read(staffListProvider.notifier).refresh(),
        ),
      ],
    );
  }

  Widget _buildBody(StaffListState staffState) {
    if (staffState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF5B67CA),
        ),
      );
    }

    if (staffState.error != null) {
      return _buildErrorState(staffState.error!);
    }

    if (staffState.staffList.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(staffListProvider.notifier).refresh(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nearby staff section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.near_me,
                  size: 18,
                  color: Color(0xFF5B67CA),
                ),
                const SizedBox(width: 8),
                Text(
                  'Available Staff',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.kSecondaryText,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (staffState.staffList.isNotEmpty)
                  Text(
                    '${staffState.staffList.length} available',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.kSuccess,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Staff list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: staffState.staffList.length,
              itemBuilder: (context, index) {
                final staff = staffState.staffList[index];
                return _buildStaffTile(staff, index);
              },
            ),
          ),

          // Info footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildStaffTile(StaffModel staff, int index) {
    final bool isNearby = index < 3; // Top 3 are considered "nearby"

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: AppColors.kSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.kBorder.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate to chat with this staff member
            context.push('/chat/${staff.userId}', extra: staff);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: _getAvatarColor(staff.userId),
                      child: Text(
                        _getInitials(staff.fullName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Online/offline indicator
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: staff.isOnline
                              ? AppColors.kSuccess
                              : AppColors.kHintText,
                          border: Border.all(
                            color: AppColors.kSurface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Staff info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              staff.fullName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: staff.isOnline
                                  ? AppColors.kSuccess.withValues(alpha: 0.1)
                                  : AppColors.kHintText.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              staff.status.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: staff.isOnline
                                    ? AppColors.kSuccess
                                    : AppColors.kHintText,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        staff.department ?? 'Support',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.kSecondaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (isNearby) ...[
                            const Icon(
                              Icons.near_me,
                              size: 12,
                              color: Color(0xFF5B67CA),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Nearby',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: const Color(0xFF5B67CA),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.kSecondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Active now',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.kSecondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.kHintText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.kBorder.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.security,
            size: 14,
            color: AppColors.kSecondaryText,
          ),
          const SizedBox(width: 6),
          Text(
            'Messages are encrypted and secure',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.kSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.kError.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load staff',
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.kSecondaryText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(staffListProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B67CA),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_off,
            size: 64,
            color: AppColors.kHintText,
          ),
          const SizedBox(height: 16),
          Text(
            'No staff available',
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'All support staff are currently offline.\nPlease check back later.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.kSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  Color _getAvatarColor(String userId) {
    final colors = [
      const Color(0xFF5B67CA),
      const Color(0xFFE91E63),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
    ];
    return colors[userId.hashCode % colors.length];
  }
}