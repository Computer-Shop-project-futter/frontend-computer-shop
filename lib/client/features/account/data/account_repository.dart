// lib/features/account/data/account_repository.dart

import 'package:flutter/foundation.dart';
import '../domain/account_model.dart';
import 'account_repository_supabase.dart';
import '../../../core/repositories/base_repository.dart';

/// Hybrid account repository using local cache with Supabase sync
class AccountRepository extends BaseRepository {
  final AccountRepositorySupabase _supabase;
  bool _isOnline = true;

  // Local cache
  UserProfile? _cachedProfile;
  List<Order> _cachedOrders = [];
  List<Address> _cachedAddresses = [];

  AccountRepository({AccountRepositorySupabase? supabase})
      : _supabase = supabase ?? AccountRepositorySupabase();

  /// Get user profile (from cache or Supabase)
  Future<UserProfile> getUserProfile() async {
    // Try to get from Supabase first
    if (_isOnline) {
      try {
        final profile = await _supabase.getUserProfile();
        _cachedProfile = profile;
        return profile;
      } catch (e) {
        debugPrint('Failed to fetch profile from Supabase: $e');
      }
    }

    // Fall back to cached profile
    if (_cachedProfile != null) {
      return _cachedProfile!;
    }

    // Default fallback
    return UserProfile(
      userId: 'user_123',
      fullName: 'User',
      email: 'user@example.com',
      phone: '+1 (555) 000-0000',
      avatarUrl: null,
      joinDate: DateTime.now(),
    );
  }

  /// Update user profile
  Future<UserProfile> updateUserProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    UserProfile updatedProfile;

    if (_isOnline) {
      try {
        updatedProfile = await _supabase.updateUserProfile(
          fullName: fullName,
          email: email,
          phone: phone,
        );
        _cachedProfile = updatedProfile;

        // Queue for offline sync
        await addToSyncQueue(
          operation: 'UPDATE',
          tableName: 'users',
          data: {
            'full_name': fullName,
            'email': email,
            'phone': phone,
            'updated_at': DateTime.now().millisecondsSinceEpoch,
          },
        );

        return updatedProfile;
      } catch (e) {
        debugPrint('Failed to update profile in Supabase: $e');
      }
    }

    // Create local version if offline
    updatedProfile = UserProfile(
      userId: _cachedProfile?.userId ?? 'user_123',
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: _cachedProfile?.avatarUrl,
      joinDate: _cachedProfile?.joinDate ?? DateTime.now(),
    );

    _cachedProfile = updatedProfile;
    return updatedProfile;
  }

  /// Get recent orders (from cache or Supabase)
  Future<List<Order>> getRecentOrders({int limit = 10}) async {
    // Try to get from Supabase first
    if (_isOnline) {
      try {
        final orders = await _supabase.getRecentOrders(limit: limit);
        _cachedOrders = orders;
        return orders;
      } catch (e) {
        debugPrint('Failed to fetch orders from Supabase: $e');
      }
    }

    // Return cached orders
    if (_cachedOrders.isNotEmpty) {
      return _cachedOrders;
    }

    // Default fallback mock data
    return [
      Order(
        id: '1',
        orderNumber: 'G14-12345',
        date: DateTime(2024, 1, 15),
        total: 2899.00,
        status: OrderStatus.delivered,
        items: const [
          OrderItem(
            id: '1',
            name: 'Apex-Ultimate Gaming Rig',
            quantity: 1,
            price: 2899.00,
          ),
        ],
      ),
      Order(
        id: '2',
        orderNumber: 'G14-12346',
        date: DateTime(2024, 1, 20),
        total: 799.00,
        status: OrderStatus.shipped,
        items: const [
          OrderItem(
            id: '3',
            name: 'VisionX 32" Ultra Display',
            quantity: 1,
            price: 799.00,
          ),
        ],
      ),
      Order(
        id: '3',
        orderNumber: 'G14-12347',
        date: DateTime(2024, 1, 25),
        total: 349.00,
        status: OrderStatus.processing,
        items: const [
          OrderItem(
            id: '4',
            name: 'Pulse Mechanical Keyboard',
            quantity: 2,
            price: 174.50,
          ),
        ],
      ),
    ];
  }

  /// Get addresses (from cache or Supabase)
  Future<List<Address>> getAddresses() async {
    // Try to get from Supabase first
    if (_isOnline) {
      try {
        final addresses = await _supabase.getAddresses();
        _cachedAddresses = addresses;
        return addresses;
      } catch (e) {
        debugPrint('Failed to fetch addresses from Supabase: $e');
      }
    }

    // Return cached addresses
    if (_cachedAddresses.isNotEmpty) {
      return _cachedAddresses;
    }

    // Default fallback mock data
    return [
      const Address(
        id: 'addr_1',
        fullName: 'User',
        street: '123 Main Street',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90001',
        country: 'United States',
        phone: '+1 (555) 000-0000',
        isDefault: true,
      ),
      const Address(
        id: 'addr_2',
        fullName: 'User',
        street: '456 Work Ave',
        city: 'San Francisco',
        state: 'CA',
        zipCode: '94105',
        country: 'United States',
        phone: '+1 (555) 000-0000',
        isDefault: false,
      ),
    ];
  }

  /// Add new address
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
    Address newAddress;

    if (_isOnline) {
      try {
        newAddress = await _supabase.addAddress(
          fullName: fullName,
          street: street,
          city: city,
          state: state,
          zipCode: zipCode,
          country: country,
          phone: phone,
          isDefault: isDefault,
        );

        _cachedAddresses.add(newAddress);

        await addToSyncQueue(
          operation: 'INSERT',
          tableName: 'addresses',
          data: {
            'address_id': newAddress.id,
            'full_name': fullName,
            'street_address': street,
            'city': city,
            'state_province': state,
            'postal_code': zipCode,
            'country': country,
            'phone_number': phone,
            'is_default': isDefault,
          },
        );

        return newAddress;
      } catch (e) {
        debugPrint('Failed to add address to Supabase: $e');
      }
    }

    // Create local version
    newAddress = Address(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      street: street,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      phone: phone,
      isDefault: isDefault,
    );

    _cachedAddresses.add(newAddress);
    return newAddress;
  }

  /// Update address
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
    Address updatedAddress;

    if (_isOnline) {
      try {
        updatedAddress = await _supabase.updateAddress(
          addressId: addressId,
          fullName: fullName,
          street: street,
          city: city,
          state: state,
          zipCode: zipCode,
          country: country,
          phone: phone,
          isDefault: isDefault,
        );

        final index =
            _cachedAddresses.indexWhere((a) => a.id == addressId);
        if (index >= 0) {
          _cachedAddresses[index] = updatedAddress;
        }

        await addToSyncQueue(
          operation: 'UPDATE',
          tableName: 'addresses',
          data: {
            'address_id': addressId,
            'full_name': fullName,
            'street_address': street,
            'city': city,
            'state_province': state,
            'postal_code': zipCode,
            'country': country,
            'phone_number': phone,
            'is_default': isDefault,
            'updated_at': DateTime.now().millisecondsSinceEpoch,
          },
        );

        return updatedAddress;
      } catch (e) {
        debugPrint('Failed to update address in Supabase: $e');
      }
    }

    // Update local cache
    updatedAddress = Address(
      id: addressId,
      fullName: fullName,
      street: street,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      phone: phone,
      isDefault: isDefault,
    );

    final index = _cachedAddresses.indexWhere((a) => a.id == addressId);
    if (index >= 0) {
      _cachedAddresses[index] = updatedAddress;
    }

    return updatedAddress;
  }

  /// Delete address
  Future<void> deleteAddress(String addressId) async {
    if (_isOnline) {
      try {
        await _supabase.deleteAddress(addressId);

        await addToSyncQueue(
          operation: 'DELETE',
          tableName: 'addresses',
          data: {'address_id': addressId},
        );
      } catch (e) {
        debugPrint('Failed to delete address from Supabase: $e');
      }
    }

    _cachedAddresses.removeWhere((a) => a.id == addressId);
  }

  /// Logout user
  Future<void> logout() async {
    if (_isOnline) {
      try {
        await _supabase.logout();
      } catch (e) {
        debugPrint('Logout error: $e');
      }
    }

    // Clear cache
    _cachedProfile = null;
    _cachedOrders = [];
    _cachedAddresses = [];
  }

  /// Set online status
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
}