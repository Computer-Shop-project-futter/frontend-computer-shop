import '../domain/user_model.dart';

class AuthResult {
  final UserModel user;
  final String? token;

  const AuthResult({required this.user, this.token});
}

class AuthRepository {
  final _mockUsers = <String, String>{}; // email -> password

  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!_mockUsers.containsKey(email)) {
      throw Exception('User not found');
    }

    if (_mockUsers[email] != password) {
      throw Exception('Invalid password');
    }

    return AuthResult(
      user: UserModel(
        userId: '123',
        roleId: _roleFromEmail(email),
        fullName: email.split('@').first,
        email: email,
        phone: '+1234567890',
        avatarUrl: null,
        createdAt: DateTime.now().toIso8601String(),
        isActive: true,
      ),
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<AuthResult> loginWithGmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!email.toLowerCase().endsWith('@gmail.com')) {
      throw Exception('Please use a valid Gmail address.');
    }

    return AuthResult(
      user: UserModel(
        userId: '123',
        roleId: _roleFromEmail(email),
        fullName: email.split('@').first,
        email: email,
        phone: '+1234567890',
        avatarUrl: null,
        createdAt: DateTime.now().toIso8601String(),
        isActive: true,
      ),
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  String _roleFromEmail(String email) {
    final normalized = email.toLowerCase();
    if (normalized.contains('admin')) {
      return 'admin';
    }
    if (normalized.contains('staff') || normalized.contains('salf')) {
      return 'staff';
    }
    return 'client';
  }

  Future<AuthResult> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_mockUsers.containsKey(email)) {
      throw Exception('Email already registered');
    }

    _mockUsers[email] = password;

    return AuthResult(
      user: UserModel(
        userId: '123',
        roleId: 'user',
        fullName: fullName,
        email: email,
        phone: phone,
        avatarUrl: null,
        createdAt: DateTime.now().toIso8601String(),
        isActive: true,
      ),
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<UserModel?> fetchProfile(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      userId: '123',
      roleId: 'user',
      fullName: 'Mock User',
      email: 'user@example.com',
      phone: '+1234567890',
      avatarUrl: null,
      createdAt: DateTime.now().toIso8601String(),
      isActive: true,
    );
  }
}
