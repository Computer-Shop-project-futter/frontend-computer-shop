import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/chat_model.dart';
import '../../domain/staff/staff_model.dart';
import '../providers/chat_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  final StaffModel? staff;
  final String? staffUserId;

  const ChatPage({
    super.key,
    this.staff,
    this.staffUserId,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasInitialized = false;

  /// Get the staff user ID from either the staff object or direct parameter
  String get _staffUserId => widget.staff?.userId ?? widget.staffUserId ?? 'default';

  /// Get the staff display name
  String get _staffName => widget.staff?.fullName ?? 'Support Chat';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    // Initialize chat on first build with the selected staff
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(chatProvider.notifier).initialize(staffUserId: _staffUserId);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.kBackground,
      appBar: _buildAppBar(chatState),
      body: Column(
        children: [
          // Connection status banner
          if (chatState.isLoading)
            const LinearProgressIndicator(
              backgroundColor: AppColors.kSurface,
              color: Color(0xFF5B67CA),
            ),

          // Main content
          Expanded(
            child: chatState.isLoading && chatState.messages.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF5B67CA),
                    ),
                  )
                : _buildMessagesSection(chatState),
          ),

          // Error banner
          if (chatState.error != null)
            _buildErrorBanner(chatState.error!),

          // Message input
          _buildMessageInput(chatState),
        ],
      ),
    );
  }

  /// Build the app bar with staff info
  PreferredSizeWidget _buildAppBar(ChatState chatState) {
    final staffInitial = _staffName.isNotEmpty
        ? _staffName.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join().toUpperCase()
        : 'S';
    final avatarColors = [
      const Color(0xFF5B67CA),
      const Color(0xFFE91E63),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
    ];
    final avatarColor = avatarColors[_staffUserId.hashCode % avatarColors.length];

    return AppBar(
      backgroundColor: AppColors.kBackground,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppColors.kPrimaryText,
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // Staff avatar with color based on staff ID
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                staffInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _staffName,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                chatState.isConnected ? 'Online' : 'Connecting...',
                style: AppTextStyles.labelSmall.copyWith(
                  color: chatState.isConnected
                      ? AppColors.kSuccess
                      : AppColors.kSecondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (chatState.thread != null)
          IconButton(
            icon: const Icon(Icons.close),
            color: AppColors.kSecondaryText,
            tooltip: 'Close chat',
            onPressed: () => _showCloseChatDialog(),
          ),
      ],
    );
  }

  /// Build the messages list section
  Widget _buildMessagesSection(ChatState chatState) {
    if (chatState.messages.isEmpty && !chatState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.kHintText,
            ),
            const SizedBox(height: 16),
            Text(
              'Start a conversation with our support team',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.kSecondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message below to get help',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: chatState.messages.length,
      itemBuilder: (context, index) {
        final message = chatState.messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  /// Build an individual message bubble
  Widget _buildMessageBubble(MessageModel message) {
    final isCustomer = message.isCustomerMessage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isCustomer ? const Color(0xFF5B67CA) : AppColors.kSurface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isCustomer
                  ? const Radius.circular(16)
                  : const Radius.circular(4),
              bottomRight: isCustomer
                  ? const Radius.circular(4)
                  : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender label
              if (!isCustomer)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Staff',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: const Color(0xFF5B67CA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              // Message text
              Text(
                message.messageText,
                style: TextStyle(
                  fontSize: 14,
                  color: isCustomer ? Colors.white : AppColors.kPrimaryText,
                ),
              ),
              const SizedBox(height: 4),
              // Timestamp
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: isCustomer
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.kHintText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format a DateTime to a time string
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (dateTime.day == now.day) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Build the message input bar
  Widget _buildMessageInput(ChatState chatState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kBackground,
        border: Border(
          top: BorderSide(color: AppColors.kBorder.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              enabled: !chatState.isSending,
              onSubmitted: (value) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.kHintText,
                ),
                filled: true,
                fillColor: AppColors.kSurface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: Color(0xFF5B67CA),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF5B67CA),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: chatState.isSending ? null : _sendMessage,
              icon: chatState.isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Build error banner
  Widget _buildErrorBanner(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.kError.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.kError, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error.replaceFirst('Exception: ', ''),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.kError,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(chatProvider.notifier).clearError(),
            child: const Icon(Icons.close, color: AppColors.kError, size: 18),
          ),
        ],
      ),
    );
  }

  /// Send the current message
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text);
    _messageController.clear();
  }

  /// Show dialog to confirm closing the chat
  void _showCloseChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Close Chat',
          style: AppTextStyles.headingSmall,
        ),
        content: Text(
          'Are you sure you want to close this chat? You can start a new one anytime.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.kSecondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(chatProvider.notifier).closeChat();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Close',
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}