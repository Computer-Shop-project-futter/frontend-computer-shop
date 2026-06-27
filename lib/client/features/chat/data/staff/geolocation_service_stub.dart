/// Stub implementation for mobile platforms
class GeolocationService {
  /// Get current user position
  /// Returns default Bangkok location on mobile
  Future<UserPosition?> getCurrentPosition() async {
    // Return default location for mobile (geolocation not implemented)
    return const UserPosition(
      latitude: 13.736717,
      longitude: 100.523186,
    );
  }
}

/// User position data class
class UserPosition {
  final double latitude;
  final double longitude;

  const UserPosition({
    required this.latitude,
    required this.longitude,
  });
}