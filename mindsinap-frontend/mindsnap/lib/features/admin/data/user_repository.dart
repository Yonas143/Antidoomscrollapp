// lib/features/admin/data/user_repository.dart

import 'package:dio/dio.dart';
import '../../../core/constants.dart';

class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await dio.get('$baseUrl/api/admin/users');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> deleteUser(String id) async {
    await dio.delete('$baseUrl/api/admin/users/$id');
  }

  Future<void> promoteToAdmin(String id) async {
    await dio.put('$baseUrl/api/admin/users/$id/role', data: {'role': 'admin'});
  }
}
