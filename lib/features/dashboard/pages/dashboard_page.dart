import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/recent_chat_model.dart';
import '../providers/dashboard_provider.dart';

import '../widgets/activity_overview_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_build_card.dart';
import '../widgets/recent_chat_card.dart';
import '../widgets/recent_repair_card.dart';
import '../widgets/statistics_grid.dart';

import 'chat_conversation_page.dart';
import 'new_build_page.dart';
import 'new_repair_page.dart';
import 'build_detail_page.dart';
import 'repair_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = DashboardProvider();
    _provider.loadDashboard();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // SnackBar Helper
  // ─────────────────────────────────────────────

  SnackBar _snack(String message, IconData icon) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.textPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      content: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
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

      case 'open_chat':
        ScaffoldMessenger.of(context).showSnackBar(
          _snack(
            'Opening chat inbox...',
            Icons.chat_bubble_outline_rounded,
          ),
        );
        break;

      case 'customers':
        ScaffoldMessenger.of(context).showSnackBar(
          _snack(
            'Opening customers...',
            Icons.people_outline_rounded,
          ),
        );
        break;
    }
  }

  // ─────────────────────────────────────────────
  // Open Chat
  // ─────────────────────────────────────────────

  void _openChat(RecentChatModel chat) {
    _provider.markChatAsRead(chat.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatConversationPage(
          chat: chat,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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
                    staffName: 'Alex Rivers',
                    branchName: 'Downtown Flagship',
                    notificationCount: 3,

                    onNotificationTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _snack(
                          'Notifications',
                          Icons.notifications_outlined,
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

                            onActionTap: () {},
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
                          // Recent Chats
                          // ─────────────────────────────

                          DashboardSectionTitle(
                            title: 'Recent Chats',

                            actionLabel: 'View All',

                            onActionTap: () {},
                          ),

                          const SizedBox(height: 12),

                          ..._provider.chats.map(
                            (chat) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10),

                              child: RecentChatCard(
                                chat: chat,

                                onTap: () => _openChat(chat),
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

                            onActionTap: () {},
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
// Sticky Header Delegate
// ─────────────────────────────────────────────

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _HeaderDelegate(this.child);

  @override
  double get minExtent => 78;

  @override
  double get maxExtent => 78;

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