import 'dart:async';
import 'dart:html' as html;

/// Service to get user's current geolocation using browser APIs
class GeolocationService {
  /// Get current user position
  /// Returns [UserPosition] with latitude and longitude
  /// Returns default Bangkok location if permission denied or unavailable
  Future<UserPosition?> getCurrentPosition() async {
    try {
      final position = await _getPosition();
      return position;
    } catch (e) {
      // Return default location (Bangkok area) as fallback
      return const UserPosition(
        latitude: 13.736717,
        longitude: 100.523186,
      );
    }
  }

  Future<UserPosition?> _getPosition() async {
    final completer = Completer<UserPosition?>();
    final dynamic geolocation = html.window.navigator.geolocation;

    if (geolocation == null) {
      completer.complete(null);
      return completer.future;
    }

    geolocation.getCurrentPosition(
      (dynamic position) {
        if (!completer.isCompleted) {
          final dynamic coords = position['coords'];
          completer.complete(UserPosition(
            latitude: coords['latitude'] as double,
            longitude: coords['longitude'] as double,
          ));
        }
      },
      (dynamic error) {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      },
    );

    return completer.future;
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