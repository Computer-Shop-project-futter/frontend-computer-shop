import 'package:dio/dio.dart';

import '../../../core/config/api_config.dart';
import '../domain/user_model.dart';

class AuthResult {
  final UserModel user;
  final String? token;

  const AuthResult({required this.user, this.token});
}

class AuthRepository {
  AuthRepository({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  Future<AuthResult> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final data = _extractMap(response.data);
    final token = _extractToken(data);
    final userMap = _extractMap(data['user']);
    final user = UserModel.fromJson(userMap.isNotEmpty ? userMap : data);
    return AuthResult(user: user, token: token);
  }

  Future<AuthResult> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    final response = await _dio.post('/auth/register', data: {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    });

    final data = _extractMap(response.data);
    final token = _extractToken(data);
    final userMap = _extractMap(data['user']);
    final user = UserModel.fromJson(userMap.isNotEmpty ? userMap : data);
    return AuthResult(user: user, token: token);
  }

  Future<UserModel?> fetchProfile(String token) async {
    final response = await _dio.get(
      '/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = _extractMap(response.data);
    if (data.isEmpty) return null;
    return UserModel.fromJson(data);
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return const {};
  }

  String? _extractToken(Map<String, dynamic> data) {
    final direct = data['token'];
    if (direct is String && direct.isNotEmpty) return direct;
    final nested = data['accessToken'];
    if (nested is String && nested.isNotEmpty) return nested;
    return null;
  }
}
