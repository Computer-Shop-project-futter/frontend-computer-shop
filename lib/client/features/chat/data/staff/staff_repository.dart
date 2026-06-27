import 'package:computer_shop/client/core/supabase/supabase_client.dart';
import 'package:computer_shop/client/features/chat/domain/staff/staff_model.dart';

/// Repository for fetching staff members with location data
class StaffRepository {
  final SupabaseClientService _supabase = SupabaseClientService();

  /// Fetch all available staff members
  Future<List<StaffModel>> getAvailableStaff() async {
    try {
      final response = await _supabase.client
          .from('users')
          .select()
          .eq('role_id', 'staff')
          .eq('is_active', true)
          .order('full_name');

      final list = List<Map<String, dynamic>>.from(response);
      return list.map((json) => StaffModel.fromJson(json)).toList();
    } catch (e) {
      // Fallback to mock data if table doesn't exist or error
      return _getMockStaff();
    }
  }

  /// Fetch staff sorted by proximity to a given location
  Future<List<StaffModel>> getNearbyStaff({
    required double userLat,
    required double userLng,
    double radiusKm = 50,
  }) async {
    final allStaff = await getAvailableStaff();

    // Calculate distances and sort by proximity
    final sorted = List<StaffModel>.from(allStaff);
    sorted.sort((a, b) {
      final distA = a.distanceFrom(userLat, userLng);
      final distB = b.distanceFrom(userLat, userLng);
      if (distA == null && distB == null) return 0;
      if (distA == null) return 1;
      if (distB == null) return -1;
      return distA.compareTo(distB);
    });

    return sorted;
  }

  /// Mock data for development / fallback
  List<StaffModel> _getMockStaff() {
    return [
      StaffModel(
        userId: 'staff-001',
        fullName: 'Sophia Chen',
        avatarUrl: null,
        department: 'Technical Support',
        latitude: 13.736717,
        longitude: 100.523186,
        isOnline: true,
        status: 'available',
      ),
      StaffModel(
        userId: 'staff-002',
        fullName: 'James Wilson',
        avatarUrl: null,
        department: 'Sales',
        latitude: 13.730000,
        longitude: 100.510000,
        isOnline: true,
        status: 'available',
      ),
      StaffModel(
        userId: 'staff-003',
        fullName: 'Maria Garcia',
        avatarUrl: null,
        department: 'Customer Service',
        latitude: 13.740000,
        longitude: 100.530000,
        isOnline: true,
        status: 'busy',
      ),
      StaffModel(
        userId: 'staff-004',
        fullName: 'Alex Johnson',
        avatarUrl: null,
        department: 'Technical Support',
        latitude: 13.720000,
        longitude: 100.540000,
        isOnline: false,
        status: 'offline',
      ),
      StaffModel(
        userId: 'staff-005',
        fullName: 'Priya Patel',
        avatarUrl: null,
        department: 'Sales',
        latitude: 13.745000,
        longitude: 100.515000,
        isOnline: true,
        status: 'available',
      ),
    ];
  }
}
