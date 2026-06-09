// lib/features/auth/data/auth_repository_supabase.dart

import '../../../core/supabase/supabase_client.dart';
import '../domain/user_model.dart';
import 'auth_repository.dart'; // Import the original AuthResult
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      final user = response.user;
      if (user == null) throw Exception('Login failed');
      
      // Get or create profile
      final profile = await _getOrCreateProfile(user);
      
      return AuthResult(
        user: profile,
        token: response.session?.accessToken,
      );
    } catch (e) {
      final raw = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      final message = raw.contains('ClientFailed to fetch')
          ? 'Cannot reach Supabase. Check your internet connection, SUPABASE_URL, and CORS settings.'
          : raw;
      print('Login error: $message');
      throw Exception(message);
    }
  }

  Future<AuthResult> register(
    String fullName,
    String email,
    String phone,
    String password,
    String roleId,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'role': roleId,
        },
      );
      
      final user = response.user;
      if (user == null) throw Exception('Registration failed');
      
      final profile = UserModel(
        userId: user.id,
        roleId: roleId,
        fullName: fullName,
        email: email,
        phone: phone,
        avatarUrl: user.userMetadata?['avatar_url'],
        createdAt: DateTime.now().toIso8601String(),
        isActive: true,
      );

      try {
        await _supabase.client
            .from('profiles')
            .insert({
              'id': user.id,
              'full_name': fullName,
              'phone': phone,
              'role': roleId,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .maybeSingle();
      } catch (profileError) {
        print('Profile insert warning: $profileError');
      }
      
      return AuthResult(
        user: profile,
        token: response.session?.accessToken,
      );
    } catch (e) {
      final raw = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      final message = raw.contains('ClientFailed to fetch')
          ? 'Cannot reach Supabase. Check your internet connection, SUPABASE_URL, and CORS settings.'
          : raw;
      print('Registration error: $message');
      throw Exception(message);
    }
  }

  Future<UserModel?> fetchProfile(String token) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      
      final response = await _supabase.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      
      if (response == null) return null;
      
      return UserModel(
        userId: user.id,
        roleId: response['role'] ?? 'customer',
        fullName: response['full_name'] ?? user.email?.split('@').first ?? '',
        email: user.email ?? '',
        phone: response['phone'] ?? '',
        avatarUrl: response['avatar_url'],
        createdAt: response['created_at']?.toString() ?? DateTime.now().toIso8601String(),
        isActive: true,
      );
    } catch (e) {
      print('Fetch profile error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<UserModel> _getOrCreateProfile(User user) async {
    try {
      final response = await _supabase.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      
      if (response != null) {
        return UserModel(
          userId: user.id,
          roleId: response['role'] ?? 'customer',
          fullName: response['full_name'] ?? user.email?.split('@').first ?? '',
          email: user.email ?? '',
          phone: response['phone'] ?? '',
          avatarUrl: response['avatar_url'],
          createdAt: response['created_at']?.toString() ?? DateTime.now().toIso8601String(),
          isActive: true,
        );
      }
      
      // Create profile if doesn't exist
      final insertResponse = await _supabase.client
          .from('profiles')
          .insert({
            'id': user.id,
            'full_name': user.email?.split('@').first ?? '',
            'email': user.email,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .maybeSingle();
      
      return UserModel(
        userId: user.id,
        roleId: insertResponse?['role'] ?? 'customer',
        fullName: insertResponse?['full_name'] ?? user.email?.split('@').first ?? '',
        email: user.email ?? '',
        phone: insertResponse?['phone'] ?? '',
        avatarUrl: insertResponse?['avatar_url'],
        createdAt: insertResponse?['created_at']?.toString() ?? DateTime.now().toIso8601String(),
        isActive: true,
      );
    } catch (e) {
      print('Get/create profile error: $e');
      rethrow;
    }
  }
}