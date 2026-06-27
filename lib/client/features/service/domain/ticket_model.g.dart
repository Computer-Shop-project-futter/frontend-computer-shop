// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
  ticketId: json['ticket_id'] as String,
  ticketNumber: json['ticket_number'] as String,
  userId: json['user_id'] as String,
  branchId: json['branch_id'] as String,
  issueType: json['issue_type'] as String,
  issueDescription: json['issue_description'] as String,
  deviceType: json['device_type'] as String,
  deviceModel: json['device_model'] as String,
  dropoffDate: DateTime.parse(json['dropoff_date'] as String),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  timeline: (json['timeline_events'] as List<dynamic>?)
      ?.map((e) => TimelineEventModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'ticket_id': instance.ticketId,
      'ticket_number': instance.ticketNumber,
      'user_id': instance.userId,
      'branch_id': instance.branchId,
      'issue_type': instance.issueType,
      'issue_description': instance.issueDescription,
      'device_type': instance.deviceType,
      'device_model': instance.deviceModel,
      'dropoff_date': instance.dropoffDate.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'timeline_events': instance.timeline,
    };

TimelineEventModel _$TimelineEventModelFromJson(Map<String, dynamic> json) =>
    TimelineEventModel(
      eventId: json['event_id'] as String,
      ticketId: json['ticket_id'] as String,
      status: json['status'] as String,
      note: json['note'] as String?,
      eventTime: DateTime.parse(json['event_time'] as String),
      staffUserId: json['staff_user_id'] as String?,
    );

Map<String, dynamic> _$TimelineEventModelToJson(TimelineEventModel instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'ticket_id': instance.ticketId,
      'status': instance.status,
      'note': instance.note,
      'event_time': instance.eventTime.toIso8601String(),
      'staff_user_id': instance.staffUserId,
    };
