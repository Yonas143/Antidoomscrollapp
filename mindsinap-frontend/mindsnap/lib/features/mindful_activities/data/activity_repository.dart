// lib/features/mindful_activities/data/activity_repository.dart

import 'package:dio/dio.dart';
import '../../../core/constants.dart';

class ActivityRepository {
  final Dio dio;

  ActivityRepository(this.dio);

  Future<void> createActivity(String title, String description) async {
    await dio.post(
      '$baseUrl/api/mindful-activities',
      data: {'title': title, 'description': description},
    );
  }

  Future<List<Map<String, dynamic>>> getUserActivities() async {
    final response = await dio.get('$baseUrl/api/mindful-activities');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> deleteActivity(String id) async {
    await dio.delete('$baseUrl/api/mindful-activities/$id');
  }
}
