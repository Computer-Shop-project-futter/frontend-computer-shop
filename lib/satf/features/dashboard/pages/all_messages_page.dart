import 'package:flutter/material.dart';
import '../models/recent_chat_model.dart';
import '../providers/dashboard_provider.dart';
import '../app_theme.dart';
import '../widgets/recent_chat_card.dart';
import 'chat_conversation_page.dart';

class AllMessagesPage extends StatefulWidget {
  final DashboardProvider provider;

  const AllMessagesPage({super.key, required this.provider});

  @override
  State<AllMessagesPage> createState() => _AllMessagesPageState();
}

class _AllMessagesPageState extends State<AllMessagesPage> {
  late final DashboardProvider _provider;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = widget.provider;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<RecentChatModel> get _filteredChats {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return _provider.chats;
    return _provider.chats.where((c) {
      return c.customerName.toLowerCase().contains(q) ||
          c.lastMessage.toLowerCase().contains(q);
    }).toList();
  }

  void _openChat(RecentChatModel chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatConversationPage(
          chat: chat,
          onChatOpened: () => _provider.markChatAsRead(chat.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chats = _filteredChats;
    final unreadCount = _provider.chats.where((c) => !c.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Messages', style: AppTextStyles.headingSmall),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$unreadCount unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: AppTextStyles.bodyMedium,
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceSecondary,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ── Chat List ───────────────────────────────────────
          Expanded(
            child: chats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            size: 54, color: AppColors.textMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 14),
                        Text(
                          _searchQuery.isNotEmpty ? 'No messages found' : 'No messages yet',
                          style: AppTextStyles.headingSmall.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: chats.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RecentChatCard(
                        chat: chats[i],
                        onTap: () => _openChat(chats[i]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}