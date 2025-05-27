// lib/features/goals/data/goal_repository.dart

import 'package:dio/dio.dart';
import '../../../core/constants.dart';

class GoalRepository {
  final Dio dio;

  GoalRepository(this.dio);

  Future<void> createGoal(String platform, int dailyLimit) async {
    await dio.post(
      '$baseUrl/api/goals',
      data: {'platform': platform, 'dailyLimit': dailyLimit},
    );
  }

  Future<List<Map<String, dynamic>>> getGoals() async {
    final response = await dio.get('$baseUrl/api/goals');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> deleteGoal(String id) async {
    await dio.delete('$baseUrl/api/goals/$id');
  }
}
