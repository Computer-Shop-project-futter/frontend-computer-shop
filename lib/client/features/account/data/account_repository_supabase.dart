// lib/features/account/data/account_repository_supabase.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/account_model.dart';

class AccountRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();
  final ImagePicker _picker = ImagePicker();

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

  /// Pick an image from gallery or camera
  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      return file;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Upload avatar image to Supabase storage and return the public URL
  /// Returns null on failure; check logs for error details
  Future<String?> uploadAvatar(File imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('ERROR: uploadAvatar - User not logged in');
      return null;
    }

    try {
      final fileExtension = imageFile.path.split('.').last;
      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = fileName;

      print('DEBUG: Uploading avatar to: avatars/$filePath');

      // Upload file - returns file path on success, throws exception on error
      final uploadedPath = await _supabase.client.storage.from('avatars').upload(
        filePath,
        imageFile,
        fileOptions: FileOptions(
          upsert: true,
          contentType: _contentTypeForExtension(fileExtension),
        ),
      );

      print('DEBUG: File uploaded successfully to: $uploadedPath');

      // Generate public URL
      final publicUrl = _supabase.client.storage.from('avatars').getPublicUrl(filePath);
      print('DEBUG: Generated public URL: $publicUrl');
      print('INFO: Avatar uploaded successfully. Public URL: $publicUrl');
      return publicUrl;
    } catch (e, stackTrace) {
      print('ERROR: Exception during avatar upload: $e');
      print('STACKTRACE: $stackTrace');
      return null;
    }
  }

  String _contentTypeForExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// Update user profile in Supabase including avatar
  Future<UserProfile> updateUserProfile({
    required String fullName,
    required String email,
    required String phone,
    XFile? avatarFile,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    String? avatarUrl;
    String? avatarUploadError;

    // Upload new avatar if provided
    if (avatarFile != null) {
      print('DEBUG: Starting avatar upload for user ${user.id}');
      avatarUrl = await uploadAvatar(File(avatarFile.path));
      if (avatarUrl == null) {
        avatarUploadError = 'Failed to upload avatar to Supabase storage';
        print('WARNING: Avatar upload failed, proceeding without avatar URL');
      }
    }

    final Map<String, dynamic> updateData = {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (avatarUrl != null) {
      updateData['avatar_url'] = avatarUrl;
    }

    // Update users table
    print('DEBUG: Updating users table for user ${user.id}');
    try {
      await _supabase.client
          .from('users')
          .update(updateData)
          .eq('user_id', user.id);
      print('DEBUG: Successfully updated users table');
    } catch (e) {
      print('ERROR: Failed to update users table: $e');
      throw Exception('Failed to update user profile in database: $e');
    }

    // Update auth user metadata
    print('DEBUG: Updating auth user metadata');
    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName,
            'phone': phone,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );
      print('DEBUG: Successfully updated auth metadata');
    } catch (e) {
      print('ERROR: Failed to update auth metadata: $e');
      throw Exception('Failed to update authentication metadata: $e');
    }

    print('INFO: Profile updated successfully');
    final updatedProfile = UserProfile(
      userId: user.id,
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl ?? user.userMetadata?['avatar_url'],
      joinDate: DateTime.parse(user.createdAt!),
    );

    if (avatarUploadError != null) {
      print('WARNING: Profile updated but $avatarUploadError');
    }

    return updatedProfile;
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
