// lib/features/auth/data/auth_repository_sqlite.dart

import 'package:computer_shop/features/auth/data/auth_repository.dart';
import 'package:computer_shop/features/auth/domain/user_model.dart';  
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/repositories/base_repository.dart';

class AuthRepositorySQLite extends BaseRepository {
  static const String _usersTable = 'users';

  Future<AuthResult> login(String email, String password) async {
    final db = await database;
    
    final result = await db.query(
      _usersTable,
      where: 'email = ? AND is_active = 1',
      whereArgs: [email],
    );
    
    if (result.isEmpty) {
      throw Exception('User not found');
    }
    
    final user = UserModel.fromDbJson(result.first as Map<String, dynamic>);
    if (user == null) {
      throw Exception('Invalid user data');
    }
    
    // In production: verify password hash
    // For mock: password stored in plain text (not recommended for production)
    
    final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
    
    // Save token to user record
    await db.update(
      _usersTable,
      {'token': token},
      where: 'user_id = ?',
      whereArgs: [user.userId],
    );
    
    // Save to SharedPreferences for quick access
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', user.userId);
    
    return AuthResult(user: user, token: token);
  }

  Future<AuthResult> register(
    String fullName,
    String email,
    String phone,
    String password,
    String roleId,
  ) async {
    final db = await database;
    
    // Check if user exists
    final existing = await db.query(
      _usersTable,
      where: 'email = ?',
      whereArgs: [email],
    );
    
    if (existing.isNotEmpty) {
      throw Exception('Email already registered');
    }
    
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final token = 'token_$userId';
    
    await db.insert(
      _usersTable,
      {
        'user_id': userId,
        'role_id': roleId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'avatar_url': null,
        'created_at': DateTime.now().toIso8601String(),
        'is_active': 1,
        'token': token,
        // In production: store hashed password
      },
    );
    
    final user = UserModel(
      userId: userId,
      roleId: roleId,
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: null,
      createdAt: DateTime.now().toIso8601String(),
      isActive: true,
    );
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', userId);
    
    return AuthResult(user: user, token: token);
  }

  Future<UserModel?> fetchProfile(String token) async {
    final db = await database;
    
    final result = await db.query(
      _usersTable,
      where: 'token = ? AND is_active = 1',
      whereArgs: [token],
    );
    
    if (result.isEmpty) return null;
    return UserModel.fromDbJson(result.first as Map<String, dynamic>);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }

  Future<void> updateUserProfile(UserModel user) async {
    final db = await database;
    await db.update(
      _usersTable,
      user.toDbJson(),
      where: 'user_id = ?',
      whereArgs: [user.userId],
    );
  }
}