import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

/// Chat thread model
/// Maps to chat_threads table
@JsonSerializable()
class ThreadModel {
  @JsonKey(name: 'thread_id')
  final String threadId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  final String status; // 'open', 'closed'

  ThreadModel({
    required this.threadId,
    required this.userId,
    required this.createdAt,
    required this.status,
  });

  bool get isOpen => status == 'open';

  factory ThreadModel.fromJson(Map<String, dynamic> json) =>
      _$ThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);
}

/// Chat message model
/// Maps to chat_messages table
@JsonSerializable()
class MessageModel {
  @JsonKey(name: 'message_id')
  final String messageId;

  @JsonKey(name: 'thread_id')
  final String threadId;

  @JsonKey(name: 'sender_type')
  final String senderType; // 'customer', 'staff', 'bot'

  @JsonKey(name: 'sender_user_id')
  final String? senderUserId;

  @JsonKey(name: 'message_text')
  final String messageText;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  MessageModel({
    required this.messageId,
    required this.threadId,
    required this.senderType,
    this.senderUserId,
    required this.messageText,
    required this.createdAt,
  });

  bool get isCustomerMessage => senderType == 'customer';
  bool get isStaffMessage => senderType == 'staff';
  bool get isBotMessage => senderType == 'bot';

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
