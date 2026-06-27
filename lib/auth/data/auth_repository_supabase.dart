// lib/auth/data/auth_repository_supabase.dart

import '../../client/core/supabase/supabase_client.dart';
import '../domain/user_model.dart';
import 'auth_repository.dart'; // Import the original AuthResult
import 'package:gotrue/gotrue.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositorySupabase {
  final SupabaseClientService _supabase = SupabaseClientService();

  String _normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(email);
  }

  String _translateAuthError(Object error) {
    if (error is AuthApiException) {
      if (error.code == 'over_email_send_rate_limit' ||
          error.message.toLowerCase().contains('email rate limit') == true) {
        return 'Too many sign-up emails were sent. Please wait a few minutes and try again.';
      }
      if (error.code == 'email_address_invalid' ||
          error.message.toLowerCase().contains('invalid email') == true) {
        return 'The email address appears invalid. Please check and try again.';
      }
      final statusCode = error.statusCode;
      if (statusCode != null && statusCode.toString() == '429') {
        return 'Too many requests. Please wait a few minutes and try again.';
      }
    }
    return error is Exception ? error.toString().replaceFirst('Exception: ', '') : error.toString();
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      final normalizedEmail = _normalizeEmail(email);
      final response = await _supabase.auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );
      
      final user = response.user;
      if (user == null) throw Exception('Login failed');
      if (user.emailConfirmedAt == null) {
        throw Exception('Email not confirmed. Please verify your email and try again.');
      }
      
      // Get or create profile
      final profile = await _getOrCreateProfile(user);
      
      return AuthResult(
        user: profile,
        token: response.session?.accessToken,
      );
    } catch (e) {
      final raw = e is AuthApiException ? _translateAuthError(e) : e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      final message = raw.contains('ClientFailed to fetch')
          ? 'Cannot reach Supabase. Check your internet connection, SUPABASE_URL, and CORS settings.'
          : raw;
      final normalized = message.toLowerCase();
      if (normalized.contains('confirm') || normalized.contains('verify')) {
        throw Exception('Email not confirmed. Please verify your email and try again.');
      }
      print('Login error: $message');
      throw Exception(message);
    }
  }

  Future<void> resendSignupVerification(String email) async {
    try {
      final normalizedEmail = _normalizeEmail(email);
      await _supabase.auth.resend(
        email: normalizedEmail,
        type: OtpType.signup,
      );
    } catch (e) {
      final message = e is AuthApiException
          ? _translateAuthError(e)
          : e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : e.toString();
      print('Resend verification error: $message');
      throw Exception(message);
    }
  }

  Future<AuthResult> verifySignupCode(String email, String code) async {
    try {
      final normalizedEmail = _normalizeEmail(email);
      final response = await _supabase.auth.verifyOTP(
        email: normalizedEmail,
        token: code,
        type: OtpType.signup,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Verification failed. Please try again.');
      }

      final profile = await _getOrCreateProfile(user);
      return AuthResult(
        user: profile,
        token: response.session?.accessToken,
      );
    } catch (e) {
      final raw = e is AuthApiException ? _translateAuthError(e) : e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      final message = raw.contains('ClientFailed to fetch')
          ? 'Cannot reach Supabase. Check your internet connection, SUPABASE_URL, and CORS settings.'
          : raw;
      print('Verification error: $message');
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
      final normalizedEmail = _normalizeEmail(email);
      if (!_isValidEmail(normalizedEmail)) {
        throw Exception('Email address "$normalizedEmail" is invalid');
      }

      // Create the auth user first; keep metadata minimal to avoid backend save failures.
      final response = await _supabase.auth.signUp(
        email: normalizedEmail,
        password: password,
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
              'email': email,
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
      final raw = _translateAuthError(e);
      final message = raw.contains('ClientFailed to fetch')
          ? 'Cannot reach Supabase. Check your internet connection, SUPABASE_URL, and CORS settings.'
          : raw;
      print('Registration error: $message');
      // Additional debug: show full exception for troubleshooting
      try {
        print('Full registration exception:');
        print(e);
      } catch (_) {}
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