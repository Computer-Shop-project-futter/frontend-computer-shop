
import 'package:computer_shop/admin/models/models.dart';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../providers/dashboard_provider.dart';
import '../models/staff_profile_model.dart';


import '../widgets/activity_overview_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_build_card.dart';
import '../widgets/recent_repair_card.dart';
import '../widgets/statistics_grid.dart';
import '../widgets/sidebar_navigation.dart';

import 'all_messages_page.dart';

import 'new_build_page.dart';
import 'new_repair_page.dart';
import 'build_detail_page.dart';
import 'repair_detail_page.dart';

import 'customers_page.dart';
import 'all_builds_page.dart';
import 'all_repairs_page.dart';
import 'profile_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardProvider _provider;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _profileStore = StaffProfileStore();


  @override
  void initState() {
    super.initState();

    _provider = DashboardProvider();
    _provider.loadDashboard();
    _profileStore.addListener(_onProfileChanged);

  }

  @override
  void dispose() {

    _profileStore.removeListener(_onProfileChanged);

    _provider.dispose();
    super.dispose();
  }


  void _onProfileChanged() {
    // Rebuild the header when profile is updated (e.g., name, avatar)
    setState(() {});

  }

  // ─────────────────────────────────────────────
  // Quick Actions
  // ─────────────────────────────────────────────

  void _handleQuickAction(String action) {
    switch (action) {
      case 'build_pc':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NewBuildPage(),
          ),
        );
        break;

      case 'add_repair':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NewRepairPage(),
          ),
        );
        break;


      case 'customers':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CustomersPage(),

          ),
        );
        break;
    }
  }

  // ─────────────────────────────────────────────

  // Add Options Bottom Sheet
  // ─────────────────────────────────────────────

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _OptionTile(
              icon: Icons.computer_outlined,
              iconColor: AppColors.primary,
              bgColor: AppColors.primarySoft,
              title: 'New PC Build',
              subtitle: 'Create a custom PC build for a customer',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewBuildPage()),
                );
              },
            ),
            const SizedBox(height: 12),
            _OptionTile(
              icon: Icons.build_outlined,
              iconColor: AppColors.warning,
              bgColor: AppColors.warningSoft,
              title: 'New Repair',
              subtitle: 'Log a repair ticket for a customer',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewRepairPage()),
                );
              },
            ),
          ],

        ),
      ),
    );
  }


  int get _chatUnreadCount =>
      _provider.chats.where((c) => !c.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: SidebarNavigation(provider: _provider),

      // ── FAB: Quick Add (bottom-right for thumb reach) ──
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,


      body: AnimatedBuilder(
        animation: _provider,

        builder: (context, _) {
          // ─────────────────────────────────────────────
          // Loading State
          // ─────────────────────────────────────────────

          if (_provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          // ─────────────────────────────────────────────
          // Error State
          // ─────────────────────────────────────────────

          if (_provider.state == DashboardLoadState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 42,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Failed to load dashboard',
                    style: AppTextStyles.headingSmall,
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _provider.refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ─────────────────────────────────────────────
          // Main UI
          // ─────────────────────────────────────────────

          return CustomScrollView(
            slivers: [
              // ─────────────────────────────────────────
              // Header
              // ─────────────────────────────────────────

              SliverPersistentHeader(
                pinned: true,
                delegate: _HeaderDelegate(
                  DashboardHeader(

                    notificationCount: _provider.pendingRequestCount,
                    chatUnreadCount: _chatUnreadCount,
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    onChatTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllMessagesPage(
                            provider: _provider,
                          ),
                        ),
                      );
                    },
                    onNotificationTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomersPage(),
                        ),
                      );
                    },
                    onProfileTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(),

                        ),
                      );
                    },
                  ),
                ),
              ),

              // ─────────────────────────────────────────
              // Dashboard Body
              // ─────────────────────────────────────────

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // ─────────────────────────────
                          // Activity Overview
                          // ─────────────────────────────

                          if (_provider.summary != null)
                            ActivityOverviewCard(
                              openTickets:
                                  _provider.summary!.totalRepairs,

                              readyPickup:
                                  _provider.summary!.pendingRepairs,

                              messages:
                                  _provider.summary!.activeChats,

                              dailyOrders:
                                  _provider.summary!.totalBuilds,
                            ),

                          const SizedBox(height: 24),

                          // ─────────────────────────────
                          // Statistics
                          // ─────────────────────────────

                          DashboardSectionTitle(
                            title: 'Statistics',

                            actionLabel: 'Details',

                            onActionTap: () {},
                          ),

                          const SizedBox(height: 12),

                          if (_provider.summary != null)
                            StatisticsGrid(
                              summary: _provider.summary!,
                            ),

                          const SizedBox(height: 24),

                          // ─────────────────────────────
                          // Quick Actions
                          // ─────────────────────────────

                          const DashboardSectionTitle(
                            title: 'Quick Actions',
                          ),

                          const SizedBox(height: 12),

                          QuickActionsRow(
                            onAction: _handleQuickAction,
                          ),

                          const SizedBox(height: 24),

                          // ─────────────────────────────
                          // Recent Repairs
                          // ─────────────────────────────

                          DashboardSectionTitle(
                            title: 'Recent Repairs',

                            actionLabel: 'View All',


                            onActionTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AllRepairsPage(
                                    provider: _provider,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          ..._provider.repairs.map(
                            (repair) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10),

                              child: RecentRepairCard(
                                repair: repair,

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RepairDetailPage(
                                        repair: repair,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ─────────────────────────────

                          // Recent Builds
                          // ─────────────────────────────

                          DashboardSectionTitle(
                            title: 'Recent PC Builds',

                            actionLabel: 'View All',


                            onActionTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AllBuildsPage(
                                    provider: _provider,
                                  ),
                                ),
                              );
                            },

                          ),

                          const SizedBox(height: 12),

                          ..._provider.builds.map(
                            (build) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10),

                              child: RecentBuildCard(
                                pcBuild: build,

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BuildDetailPage(
                                        pcBuild: build,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),


                          const SizedBox(height: 24),

                          const DashboardSectionTitle(title: 'Recent Feedback'),
                          const SizedBox(height: 12),

                          if (_provider.feedbacks.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                'No feedback yet',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            )
                          else
                            ..._provider.feedbacks.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.rate_review_rounded,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.customerName,
                                              style: AppTextStyles.headingSmall.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.message,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.textSecondary,
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                ...List.generate(
                                                  item.rating,
                                                  (_) => const Icon(
                                                    Icons.star_rounded,
                                                    size: 14,
                                                    color: AppColors.warning,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: item.status.color
                                                            .withOpacity(0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    item.status.label,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: item.status.color,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          const DashboardSectionTitle(title: 'Active Promotions'),
                          const SizedBox(height: 12),


                          const SizedBox(height: 24),

                          const DashboardSectionTitle(title: 'Active Promotions'),
                          const SizedBox(height: 12),

                          if (_provider.promotions.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                'No active promotions',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            )
                          else
                            ..._provider.promotions.map(
                              (promo) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: promo.type.badgeColor
                                              .withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.campaign_rounded,
                                          color: promo.type.badgeColor,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              promo.title,
                                              style: AppTextStyles.headingSmall
                                                  .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              promo.subtitle,
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                color: AppColors.textMuted,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          const DashboardSectionTitle(title: 'Active Coupons'),
                          const SizedBox(height: 12),

                          if (_provider.coupons.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                'No active coupons',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            )
                          else
                            ..._provider.coupons.map(
                              (coupon) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.primarySoft,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.card_giftcard_rounded,
                                          color: AppColors.primary,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              coupon.code,
                                              style: AppTextStyles.headingSmall
                                                  .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.4,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              coupon.summaryLine,
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────

// Add Option Tile
// ─────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headingSmall.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────

// Sticky Header Delegate
// ─────────────────────────────────────────────

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _HeaderDelegate(this.child);

  @override

  double get minExtent => 75;

  @override
  double get maxExtent => 75;


  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }

}

