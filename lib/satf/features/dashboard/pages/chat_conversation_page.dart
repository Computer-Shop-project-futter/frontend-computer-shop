import 'package:flutter/material.dart';
import '../models/recent_chat_model.dart';
import '../app_theme.dart';

class _ChatMessage {
  final String text;
  final bool isStaff;
  final DateTime time;
  _ChatMessage({required this.text, required this.isStaff, required this.time});
}

class ChatConversationPage extends StatefulWidget {
  final RecentChatModel chat;

  const ChatConversationPage({super.key, required this.chat});

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  late List<_ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Static starter messages — replace with API WebSocket/polling later
    _messages = [
      _ChatMessage(
        text: widget.chat.lastMessage,
        isStaff: false,
        time: widget.chat.timestamp,
      ),
      _ChatMessage(
        text: "Hi! Thanks for reaching out. Let me look into that for you right away.",
        isStaff: true,
        time: now.subtract(const Duration(minutes: 1)),
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isStaff: true,
        time: DateTime.now(),
      ));
    });
    _textController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  widget.chat.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.customerName,
                  style: AppTextStyles.headingSmall.copyWith(fontSize: 15),
                ),
                Text(
                  'Customer',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 20),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          // ── Messages List ──────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                return _MessageBubble(message: _messages[i]);
              },
            ),
          ),
          // ── Input Bar ─────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              10,
              16,
              MediaQuery.of(context).viewInsets.bottom + 14,
            ),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTextStyles.bodyMedium,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            message.isStaff ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isStaff) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.person, size: 14, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isStaff
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: message.isStaff
                        ? AppColors.primary
                        : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isStaff ? 16 : 4),
                      bottomRight: Radius.circular(message.isStaff ? 4 : 16),
                    ),
                    border: message.isStaff
                        ? null
                        : Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: message.isStaff
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(message.time),
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          if (message.isStaff) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'AR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}