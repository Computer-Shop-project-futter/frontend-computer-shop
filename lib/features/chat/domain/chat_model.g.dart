// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadModel _$ThreadModelFromJson(Map<String, dynamic> json) => ThreadModel(
  threadId: json['thread_id'] as String,
  userId: json['user_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$ThreadModelToJson(ThreadModel instance) =>
    <String, dynamic>{
      'thread_id': instance.threadId,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'status': instance.status,
    };

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  messageId: json['message_id'] as String,
  threadId: json['thread_id'] as String,
  senderType: json['sender_type'] as String,
  senderUserId: json['sender_user_id'] as String?,
  messageText: json['message_text'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'thread_id': instance.threadId,
      'sender_type': instance.senderType,
      'sender_user_id': instance.senderUserId,
      'message_text': instance.messageText,
      'created_at': instance.createdAt.toIso8601String(),
    };
