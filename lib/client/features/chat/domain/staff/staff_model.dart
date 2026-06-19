import 'dart:math';

/// Staff model for support chat
/// Represents a staff member with location data for nearby tracking
class StaffModel {
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String? department;
  final double? latitude;
  final double? longitude;
  final DateTime? lastLocationUpdate;
  final bool isOnline;
  final String status; // 'available', 'busy', 'offline'

  StaffModel({
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.department,
    this.latitude,
    this.longitude,
    this.lastLocationUpdate,
    this.isOnline = false,
    this.status = 'offline',
  });

  /// Calculate distance in kilometers from a given position
  double? distanceFrom(double lat, double lng) {
    if (latitude == null || longitude == null) return null;

    const earthRadius = 6371; // km
    final dLat = _toRadians(lat - latitude!);
    final dLng = _toRadians(lng - longitude!);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(latitude!)) *
            cos(_toRadians(lat)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  String get distanceText {
    return 'Nearby'; // Will be calculated dynamically
  }

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      userId: json['user_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      department: json['department']?.toString(),
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      lastLocationUpdate: json['last_location_update'] != null
          ? DateTime.tryParse(json['last_location_update'].toString())
          : null,
      isOnline: json['is_online'] == true || json['is_online'] == 1,
      status: json['status']?.toString() ?? 'offline',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'department': department,
        'latitude': latitude,
        'longitude': longitude,
        'last_location_update': lastLocationUpdate?.toIso8601String(),
        'is_online': isOnline,
        'status': status,
      };
}