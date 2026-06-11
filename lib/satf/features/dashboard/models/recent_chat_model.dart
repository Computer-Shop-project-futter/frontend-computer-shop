class RecentChatModel {
  final String id;
  final String customerName;
  final String lastMessage;
  final DateTime timestamp;
  final bool isRead;
  final int unreadCount;
  final String? avatarInitials;

  const RecentChatModel({
    required this.id,
    required this.customerName,
    required this.lastMessage,
    required this.timestamp,
    required this.isRead,
    this.unreadCount = 0,
    this.avatarInitials,
  });

  String get initials {
    if (avatarInitials != null) return avatarInitials!;
    final parts = customerName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return customerName.isNotEmpty ? customerName[0].toUpperCase() : '?';
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  // Static mock list — replace with API data later
  static List<RecentChatModel> mockList() {
    final now = DateTime.now();
    return [
      RecentChatModel(
        id: 'CH-001',
        customerName: 'Julianne Smith',
        lastMessage: 'Is the lean suit still available in size 4?',
        timestamp: now.subtract(const Duration(minutes: 2)),
        isRead: false,
        unreadCount: 2,
      ),
      RecentChatModel(
        id: 'CH-002',
        customerName: 'Marcus Wright',
        lastMessage: "I'd like to update my shipping address for...",
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
        unreadCount: 1,
      ),
      RecentChatModel(
        id: 'CH-003',
        customerName: 'Elena Belova',
        lastMessage: 'Thank you for the quick help with the retu...',
        timestamp: now.subtract(const Duration(minutes: 31)),
        isRead: true,
        unreadCount: 0,
      ),
      RecentChatModel(
        id: 'CH-004',
        customerName: 'David Kim',
        lastMessage: 'Are there any upcoming sales I should know...',
        timestamp: now.subtract(const Duration(minutes: 31)),
        isRead: true,
        unreadCount: 0,
      ),
      RecentChatModel(
        id: 'CH-005',
        customerName: 'Sarah Thompson',
        lastMessage: "The tracking link isn't working for me.",
        timestamp: now.subtract(const Duration(minutes: 51)),
        isRead: true,
        unreadCount: 0,
      ),
    ];
  }
}