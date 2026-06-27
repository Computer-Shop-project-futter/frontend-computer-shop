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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 900;

    if (staffState.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF5B67CA),
          strokeWidth: isWideScreen ? 3 : 2.5,
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
            padding: EdgeInsets.fromLTRB(
              isWideScreen ? 24 : 16,
              isWideScreen ? 20 : 16,
              isWideScreen ? 24 : 16,
              isWideScreen ? 10 : 8,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.near_me,
                  size: isWideScreen ? 22 : 18,
                  color: const Color(0xFF5B67CA),
                ),
                SizedBox(width: isWideScreen ? 12 : 8),
                Text(
                  'Available Staff',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.kSecondaryText,
                    letterSpacing: 0.5,
                    fontSize: isWideScreen ? 15 : 13,
                  ),
                ),
                const Spacer(),
                if (staffState.staffList.isNotEmpty)
                  Text(
                    '${staffState.staffList.length} available',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.kSuccess,
                      fontSize: isWideScreen ? 12 : 11,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: isWideScreen ? 6 : 4),

          // Staff list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 24 : 16,
                vertical: isWideScreen ? 8 : 4,
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 900;
    final isMediumScreen = screenWidth >= 600;

    // Responsive sizing
    final avatarRadius = isWideScreen ? 32.0 : (isMediumScreen ? 28.0 : 24.0);
    final avatarFontSize = isWideScreen ? 18.0 : (isMediumScreen ? 16.0 : 14.0);
    final onlineIndicatorSize = isWideScreen ? 14.0 : (isMediumScreen ? 12.0 : 10.0);
    final cardPadding = isWideScreen ? 16.0 : (isMediumScreen ? 14.0 : 12.0);
    final spacing = isWideScreen ? 16.0 : (isMediumScreen ? 14.0 : 12.0);
    final nameFontSize = isWideScreen ? 16.0 : 14.0;
    final badgeFontSize = isWideScreen ? 11.0 : 10.0;

    return Padding(
      padding: EdgeInsets.only(bottom: isWideScreen ? 12 : 8),
      child: Card(
        elevation: 0,
        color: AppColors.kSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isWideScreen ? 16 : 12),
          side: BorderSide(
            color: AppColors.kBorder.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(isWideScreen ? 16 : 12),
          onTap: () {
            // Navigate to chat with this staff member
            context.push('/chat/${staff.userId}', extra: staff);
          },
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: _getAvatarColor(staff.userId),
                      child: Text(
                        _getInitials(staff.fullName),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: avatarFontSize,
                        ),
                      ),
                    ),
                    // Online/offline indicator
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: onlineIndicatorSize,
                        height: onlineIndicatorSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: staff.isOnline
                              ? AppColors.kSuccess
                              : AppColors.kHintText,
                          border: Border.all(
                            color: AppColors.kSurface,
                            width: isWideScreen ? 2.5 : 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: spacing),

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
                                fontSize: nameFontSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Status badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWideScreen ? 10 : 8,
                              vertical: isWideScreen ? 3 : 2,
                            ),
                            decoration: BoxDecoration(
                              color: staff.isOnline
                                  ? AppColors.kSuccess.withValues(alpha: 0.1)
                                  : AppColors.kHintText.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(isWideScreen ? 12 : 10),
                            ),
                            child: Text(
                              staff.status.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: staff.isOnline
                                    ? AppColors.kSuccess
                                    : AppColors.kHintText,
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isWideScreen ? 4 : 2),
                      Text(
                        staff.department ?? 'Support',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.kSecondaryText,
                          fontSize: isWideScreen ? 13 : 12,
                        ),
                      ),
                      SizedBox(height: isWideScreen ? 4 : 2),
                      Row(
                        children: [
                          if (isNearby) ...[
                            Icon(
                              Icons.near_me,
                              size: isWideScreen ? 14 : 12,
                              color: const Color(0xFF5B67CA),
                            ),
                            SizedBox(width: isWideScreen ? 6 : 4),
                            Text(
                              'Nearby',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: const Color(0xFF5B67CA),
                                fontWeight: FontWeight.w500,
                                fontSize: isWideScreen ? 12 : 11,
                              ),
                            ),
                            SizedBox(width: isWideScreen ? 10 : 8),
                          ],
                          Icon(
                            Icons.access_time,
                            size: isWideScreen ? 14 : 12,
                            color: AppColors.kSecondaryText,
                          ),
                          SizedBox(width: isWideScreen ? 6 : 4),
                          Text(
                            'Active now',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.kSecondaryText,
                              fontSize: isWideScreen ? 12 : 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                Icon(
                  Icons.chevron_right,
                  color: AppColors.kHintText,
                  size: isWideScreen ? 28 : 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 900;

    return Container(
      padding: EdgeInsets.all(isWideScreen ? 20 : 16),
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
          Icon(
            Icons.security,
            size: isWideScreen ? 16 : 14,
            color: AppColors.kSecondaryText,
          ),
          SizedBox(width: isWideScreen ? 8 : 6),
          Text(
            'Messages are encrypted and secure',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.kSecondaryText,
              fontSize: isWideScreen ? 12 : 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 900;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isWideScreen ? 48 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isWideScreen ? 80 : 64,
              color: AppColors.kError.withValues(alpha: 0.5),
            ),
            SizedBox(height: isWideScreen ? 24 : 16),
            Text(
              'Could not load staff',
              style: AppTextStyles.headingSmall.copyWith(
                fontSize: isWideScreen ? 22 : 18,
              ),
            ),
            SizedBox(height: isWideScreen ? 12 : 8),
            Text(
              error.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.kSecondaryText,
                fontSize: isWideScreen ? 15 : 14,
              ),
            ),
            SizedBox(height: isWideScreen ? 32 : 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(staffListProvider.notifier).refresh(),
              icon: Icon(Icons.refresh, size: isWideScreen ? 22 : 20),
              label: Text(
                'Try Again',
                style: TextStyle(fontSize: isWideScreen ? 15 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B67CA),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 28 : 24,
                  vertical: isWideScreen ? 16 : 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 900;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isWideScreen ? 48 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: isWideScreen ? 80 : 64,
              color: AppColors.kHintText,
            ),
            SizedBox(height: isWideScreen ? 24 : 16),
            Text(
              'No staff available',
              style: AppTextStyles.headingSmall.copyWith(
                fontSize: isWideScreen ? 22 : 18,
              ),
            ),
            SizedBox(height: isWideScreen ? 12 : 8),
            Text(
              'All support staff are currently offline.\nPlease check back later.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.kSecondaryText,
                fontSize: isWideScreen ? 15 : 14,
              ),
            ),
          ],
        ),
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