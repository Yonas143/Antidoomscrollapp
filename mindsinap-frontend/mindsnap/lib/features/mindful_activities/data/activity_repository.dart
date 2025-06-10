import 'package:dio/dio.dart';
import '../../../models/activity.dart';

class ActivityRepository {
  final Dio _dio;

  ActivityRepository(this._dio);

  /// GET all activities for the current user
  Future<List<Activity>> getAllActivities() async {
    final response = await _dio.get('/api/mindful-activities');

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  /// POST a new activity
  Future<Activity> createActivity(Activity activity) async {
    final response = await _dio.post(
      '/api/mindful-activities',
      data: activity.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Activity.fromJson(response.data);
    } else {
      throw Exception('Failed to create activity');
    }
  }

  /// DELETE an activity by ID
  Future<void> deleteActivity(String id) async {
    final response = await _dio.delete('/api/mindful-activities/$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }
}
