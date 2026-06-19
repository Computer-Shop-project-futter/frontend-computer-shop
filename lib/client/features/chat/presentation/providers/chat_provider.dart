import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_model.dart';

/// Chat state definition
class ChatState {
  final ThreadModel? thread;
  final List<MessageModel> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;
  final bool isConnected;

  const ChatState({
    this.thread,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.isConnected = false,
  });

  ChatState copyWith({
    ThreadModel? thread,
    List<MessageModel>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
    bool? isConnected,
  }) {
    return ChatState(
      thread: thread ?? this.thread,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

/// Chat provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repository = ChatRepository();
  return ChatNotifier(repository);
});

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  StreamSubscription<MessageModel>? _messageSubscription;

  ChatNotifier(this._repository) : super(const ChatState());

  /// Initialize the chat: get or create thread and load messages
  /// [staffUserId] - the staff member to chat with (like Messenger per-person chat)
  Future<void> initialize({String? staffUserId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final thread = await _repository.getOrCreateThread(staffUserId ?? 'default');
      final messages = await _repository.getMessages(thread.threadId);

      state = state.copyWith(
        thread: thread,
        messages: messages,
        isLoading: false,
        isConnected: true,
      );

      // Start listening for new messages
      _startMessageListener(thread.threadId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize chat: ${e.toString()}',
      );
    }
  }

  /// Send a new message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.thread == null) return;

    state = state.copyWith(isSending: true, error: null);

    try {
      final message = await _repository.sendMessage(
        threadId: state.thread!.threadId,
        messageText: text.trim(),
      );

      state = state.copyWith(
        messages: [...state.messages, message],
        isSending: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: 'Failed to send message: ${e.toString()}',
      );
    }
  }

  /// Close the chat thread
  Future<void> closeChat() async {
    if (state.thread == null) return;

    try {
      await _repository.closeThread(state.thread!.threadId);
      _messageSubscription?.cancel();
      state = state.copyWith(
        thread: null,
        messages: [],
        isConnected: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to close chat: ${e.toString()}',
      );
    }
  }

  /// Listen for new messages in real-time
  void _startMessageListener(String threadId) {
    _messageSubscription?.cancel();

    final stream = _repository.subscribeToMessages(threadId);
    _messageSubscription = stream.listen((message) {
      // Avoid adding duplicate messages
      final exists = state.messages.any((m) => m.messageId == message.messageId);
      if (!exists) {
        state = state.copyWith(
          messages: [...state.messages, message],
        );
      }
    });
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _repository.dispose();
    super.dispose();
  }
}