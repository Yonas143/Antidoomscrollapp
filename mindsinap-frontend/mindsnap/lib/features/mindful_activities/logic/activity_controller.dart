import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/activity.dart';
import '../data/activity_repository.dart';

class ActivityController extends StateNotifier<List<Activity>> {
  final ActivityRepository _repo;

  ActivityController(this._repo) : super([]) {
    loadActivities(); // Automatically load on init
  }

  /// Load all activities for current user
  Future<void> loadActivities() async {
    try {
      final activities = await _repo.getAllActivities();

      state = activities;
    } catch (e) {
      // Log or handle error appropriately
      print('Failed to load activities: $e');
    }
  }

  /// Create new activity and update state
  Future<void> create(String title, String description, String userId) async {
    try {
      final newActivity = Activity(
        id: '', // The backend will assign this
        title: title,
        description: description,
        date: DateTime.now(),
        userId: userId,
      );

      final created = await _repo.createActivity(newActivity);
      state = [...state, created];
    } catch (e) {
      print('Failed to create activity: $e');
    }
  }

  /// Delete an activity by id
  Future<void> delete(String id) async {
    try {
      await _repo.deleteActivity(id);
      state = state.where((activity) => activity.id != id).toList();
    } catch (e) {
      print('Failed to delete activity: $e');
    }
  }
}
