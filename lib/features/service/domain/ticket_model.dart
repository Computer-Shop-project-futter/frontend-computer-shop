import 'package:json_annotation/json_annotation.dart';

part 'ticket_model.g.dart';

/// Service ticket model
/// Maps to service_tickets table
@JsonSerializable()
class TicketModel {
  @JsonKey(name: 'ticket_id')
  final String ticketId;

  @JsonKey(name: 'ticket_number')
  final String ticketNumber;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'branch_id')
  final String branchId;

  @JsonKey(name: 'issue_type')
  final String issueType;

  @JsonKey(name: 'issue_description')
  final String issueDescription;

  @JsonKey(name: 'device_type')
  final String deviceType;

  @JsonKey(name: 'device_model')
  final String deviceModel;

  @JsonKey(name: 'dropoff_date')
  final DateTime dropoffDate;

  final String status; // 'open', 'in_progress', 'waiting', 'completed', 'closed'

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'timeline_events')
  final List<TimelineEventModel>? timeline;

  TicketModel({
    required this.ticketId,
    required this.ticketNumber,
    required this.userId,
    required this.branchId,
    required this.issueType,
    required this.issueDescription,
    required this.deviceType,
    required this.deviceModel,
    required this.dropoffDate,
    required this.status,
    required this.createdAt,
    this.timeline,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);
}

/// Timeline event model
/// Maps to ticket_timeline_events table
@JsonSerializable()
class TimelineEventModel {
  @JsonKey(name: 'event_id')
  final String eventId;

  @JsonKey(name: 'ticket_id')
  final String ticketId;

  final String status;
  final String? note;

  @JsonKey(name: 'event_time')
  final DateTime eventTime;

  @JsonKey(name: 'staff_user_id')
  final String? staffUserId;

  TimelineEventModel({
    required this.eventId,
    required this.ticketId,
    required this.status,
    this.note,
    required this.eventTime,
    this.staffUserId,
  });

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineEventModelToJson(this);
}
