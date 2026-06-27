import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:computer_shop/client/core/supabase/supabase_client.dart';
import 'package:computer_shop/client/features/chat/domain/chat_model.dart';

/// Repository for chat operations using Supabase as the backend
/// Supports multi-staff threads: each staff member has a separate thread
class ChatRepository {
  final SupabaseClientService _supabase = SupabaseClientService();
  RealtimeChannel? _realtimeChannel;
  Timer? _pollingTimer;

  /// Get the current authenticated user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Get or create a chat thread for a specific staff member
  /// Each staff gets their own thread, like Messenger
  Future<ThreadModel> getOrCreateThread(String staffUserId) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      // Look for an existing open thread with this specific staff
      final existingThreads = await _supabase.client
          .from('chat_threads')
          .select()
          .eq('user_id', userId)
          .eq('staff_user_id', staffUserId)
          .eq('status', 'open')
          .order('created_at', ascending: false)
          .limit(1);

      if (existingThreads.isNotEmpty) {
        return ThreadModel.fromJson(existingThreads[0]);
      }

      // Create new thread for this staff
      final response = await _supabase.client
          .from('chat_threads')
          .insert({
            'user_id': userId,
            'staff_user_id': staffUserId,
            'status': 'open',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return ThreadModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create chat thread: $e');
    }
  }

  /// Fetch messages for a given thread, ordered by creation time
  Future<List<MessageModel>> getMessages(String threadId) async {
    try {
      final response = await _supabase.client
          .from('chat_messages')
          .select()
          .eq('thread_id', threadId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => MessageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  /// Send a new message in a thread
  Future<MessageModel> sendMessage({
    required String threadId,
    required String messageText,
  }) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _supabase.client
          .from('chat_messages')
          .insert({
            'thread_id': threadId,
            'sender_type': 'customer',
            'sender_user_id': userId,
            'message_text': messageText,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return MessageModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Close a chat thread
  Future<void> closeThread(String threadId) async {
    try {
      await _supabase.client
          .from('chat_threads')
          .update({'status': 'closed'})
          .eq('thread_id', threadId);
    } catch (e) {
      throw Exception('Failed to close thread: $e');
    }
  }

  /// Get last message timestamp to use for polling new messages
  Future<DateTime?> getLastMessageTimestamp(String threadId) async {
    try {
      final response = await _supabase.client
          .from('chat_messages')
          .select('created_at')
          .eq('thread_id', threadId)
          .order('created_at', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        return DateTime.parse(response[0]['created_at'] as String);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Subscribe to new messages in a thread using polling
  /// Polls every 3 seconds for new messages
  Stream<MessageModel> subscribeToMessages(String threadId) {
    final streamController = StreamController<MessageModel>.broadcast();
    DateTime? lastTimestamp;

    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final response = await _supabase.client
            .from('chat_messages')
            .select()
            .eq('thread_id', threadId)
            .order('created_at', ascending: true);

        final messages = (response as List)
            .map((json) => MessageModel.fromJson(json as Map<String, dynamic>))
            .toList();

        for (final message in messages) {
          if (lastTimestamp == null || message.createdAt.isAfter(lastTimestamp!)) {
            streamController.add(message);
          }
        }

        if (messages.isNotEmpty) {
          lastTimestamp = messages.last.createdAt;
        }
      } catch (_) {
        // Silently handle polling errors
      }
    });

    streamController.onCancel = () {
      _pollingTimer?.cancel();
      _pollingTimer = null;
    };

    return streamController.stream;
  }

  /// Dispose repository resources
  void dispose() {
    _pollingTimer?.cancel();
    _realtimeChannel?.unsubscribe();
  }
}