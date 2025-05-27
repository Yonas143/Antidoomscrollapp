// lib/features/auth/data/auth_repository.dart

import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<String> login(String username, String password) async {
    final response = await _dio.post('/api/login', data: {
      'username': username,
      'password': password,
    });
    return response.data['token'];
  }

  Future<String> register(String username, String password) async {
    final response = await _dio.post('/api/register', data: {
      'username': username,
      'password': password,
    });
    return response.data['token'];
  }
}
