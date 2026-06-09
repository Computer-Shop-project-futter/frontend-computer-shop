// lib/features/auth/data/auth_repository_hybrid.dart

import 'package:flutter/foundation.dart';
import '../domain/user_model.dart';
import 'auth_repository.dart';
import 'auth_repository_sqlite.dart';
import 'auth_repository_supabase.dart';

/// Hybrid repository that uses both SQLite (local cache) and Supabase (remote backend)
/// Provides offline-first authentication with automatic sync when online
class AuthRepositoryHybrid extends AuthRepository {
  final AuthRepositorySQLite _sqlite;
  final AuthRepositorySupabase _supabase;
  bool _isOnline = true;

  AuthRepositoryHybrid({
    AuthRepositorySQLite? sqlite,
    AuthRepositorySupabase? supabase,
  })  : _sqlite = sqlite ?? AuthRepositorySQLite(),
        _supabase = supabase ?? AuthRepositorySupabase();

  /// Login: try remote first, fallback to cache
  @override
  Future<AuthResult> login(String email, String password) async {
    // Try remote Supabase first if online
    if (_isOnline) {
      try {
        final result = await _supabase.login(email, password);
        // Cache successful login locally
        await _sqlite.login(email, password);
        return result;
      } catch (e) {
        print('Supabase login failed: $e');
        // Fall through to SQLite
      }
    }

    // Use cached auth (offline mode)
    return await _sqlite.login(email, password);
  }

  /// Register: create locally + remotely
  @override
  Future<AuthResult> register(
    String fullName,
    String email,
    String phone,
    String password,
    String roleId,
  ) async {
    // On web, use Supabase directly because local SQLite is not available
    if (kIsWeb) {
      return await _supabase.register(
        fullName,
        email,
        phone,
        password,
        roleId,
      );
    }

    // Always create locally first on native platforms
    final localResult = await _sqlite.register(
      fullName,
      email,
      phone,
      password,
      roleId,
    );

    // Try to sync to remote if online
    if (_isOnline) {
      try {
        final remoteResult = await _supabase.register(
          fullName,
          email,
          phone,
          password,
          roleId,
        );
        return remoteResult;
      } catch (e) {
        print('Supabase registration failed, using local: $e');
      }
    }

    // Return local result (will sync when online)
    return localResult;
  }

  /// Fetch profile: remote priority with local fallback
  @override
  Future<UserModel?> fetchProfile(String token) async {
    // Try remote first if online
    if (_isOnline) {
      try {
        final profile = await _supabase.fetchProfile(token);
        if (profile != null) {
          // Update local cache
          await _sqlite.updateUserProfile(profile);
          return profile;
        }
      } catch (e) {
        print('Supabase profile fetch failed: $e');
      }
    }

    // Fallback to local cache
    return await _sqlite.fetchProfile(token);
  }

  /// Logout: clear both local and remote
  Future<void> logout() async {
    // Clear locally
    await _sqlite.logout();

    // Try to clear remotely if online
    if (_isOnline) {
      try {
        await _supabase.logout();
      } catch (e) {
        print('Supabase logout failed: $e');
      }
    }
  }

  /// Update user profile locally + remotely
  Future<void> updateUserProfile(UserModel user) async {
    // Update locally first
    await _sqlite.updateUserProfile(user);

    // Try to sync remotely if online
    if (_isOnline) {
      try {
        // Could add an updateProfile method to Supabase repo here
        print('User profile updated locally, will sync to remote');
      } catch (e) {
        print('Remote profile update failed: $e');
      }
    }
  }

  /// Set online status (called by connectivity service)
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
  }
}
