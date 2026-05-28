import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? message;

  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);

  const AuthState.loading() : this(status: AuthStatus.loading);

  const AuthState.authenticated(UserModel user)
      : this(status: AuthStatus.authenticated, user: user);

  const AuthState.error(String message)
      : this(status: AuthStatus.error, message: message);
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.unauthenticated());

  final AuthRepository _repository;

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final result = await _repository.login(email, password);
      if (result.token != null) {
        await _saveToken(result.token!);
      }
      state = AuthState.authenticated(result.user);
    } catch (error) {
      state = AuthState.error('Login failed. Please try again.');
    }
  }

  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    state = const AuthState.loading();
    try {
      final result = await _repository.register(fullName, email, phone, password);
      if (result.token != null) {
        await _saveToken(result.token!);
      }
      state = AuthState.authenticated(result.user);
    } catch (error) {
      state = AuthState.error('Registration failed. Please try again.');
    }
  }

  Future<bool> checkAuth() async {
    state = const AuthState.loading();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      state = const AuthState.unauthenticated();
      return false;
    }

    try {
      final user = await _repository.fetchProfile(token);
      if (user == null) {
        state = const AuthState.unauthenticated();
        return false;
      }
      state = AuthState.authenticated(user);
      return true;
    } catch (_) {
      state = const AuthState.unauthenticated();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    state = const AuthState.unauthenticated();
  }

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
