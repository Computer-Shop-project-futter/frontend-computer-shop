// lib/features/account/data/account_repository_supabase.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/account_model.dart';

class AccountRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  /// Get current user profile from Supabase
  Future<UserProfile> getUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _supabase.client
          .from('users')
          .select()
          .eq('user_id', user.id)
          .single();

      return UserProfile.fromDbJson(response);
    } catch (e) {
      // Fallback: use auth user data
      return UserProfile(
        userId: user.id,
        fullName: user.userMetadata?['full_name'] ?? 'User',
        email: user.email ?? '',
        phone: user.userMetadata?['phone'] ?? '',
        avatarUrl: user.userMetadata?['avatar_url'],
        joinDate: DateTime.parse(user.createdAt!),
      );
    }
  }

  /// Update user profile in Supabase
  Future<UserProfile> updateUserProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Update auth user metadata
    await _supabase.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': fullName,
          'phone': phone,
        },
      ),
    );

    // Update users table
    await _supabase.client
        .from('users')
        .update({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', user.id);

    return UserProfile(
      userId: user.id,
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: user.userMetadata?['avatar_url'],
      joinDate: DateTime.parse(user.createdAt!),
    );
  }

  /// Get user's recent orders from Supabase
  Future<List<Order>> getRecentOrders({int limit = 10}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase.client
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => Order.fromDbJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  /// Get user's addresses from Supabase
  Future<List<Address>> getAddresses() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase.client
          .from('addresses')
          .select()
          .eq('user_id', user.id)
          .order('is_default', ascending: false);

      return (response as List)
          .map((json) => Address.fromDbJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching addresses: $e');
      return [];
    }
  }

  /// Add a new address
  Future<Address> addAddress({
    required String fullName,
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required String phone,
    bool isDefault = false,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final response = await _supabase.client
        .from('addresses')
        .insert({
          'user_id': user.id,
          'full_name': fullName,
          'street_address': street,
          'city': city,
          'state_province': state,
          'postal_code': zipCode,
          'country': country,
          'phone_number': phone,
          'is_default': isDefault,
        })
        .select()
        .single();

    return Address.fromDbJson(response);
  }

  /// Update an existing address
  Future<Address> updateAddress({
    required String addressId,
    required String fullName,
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required String phone,
    bool isDefault = false,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final response = await _supabase.client
        .from('addresses')
        .update({
          'full_name': fullName,
          'street_address': street,
          'city': city,
          'state_province': state,
          'postal_code': zipCode,
          'country': country,
          'phone_number': phone,
          'is_default': isDefault,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', user.id)
        .eq('address_id', addressId)
        .select()
        .single();

    return Address.fromDbJson(response);
  }

  /// Delete an address
  Future<void> deleteAddress(String addressId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.client
        .from('addresses')
        .delete()
        .eq('user_id', user.id)
        .eq('address_id', addressId);
  }

  /// Logout user
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
