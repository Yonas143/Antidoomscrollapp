// lib/features/mindful_activities/logic/activity_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/activity_repository.dart';

final activityControllerProvider = StateNotifierProvider<ActivityController, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final repo = ref.read(activityRepoProvider);
  return ActivityController(repo);
});

class ActivityController extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final ActivityRepository repo;

  ActivityController(this.repo) : super(const AsyncValue.loading()) {
    loadActivities();
  }

  Future<void> loadActivities() async {
    try {
      final data = await repo.getUserActivities();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> create(String title, String description) async {
    try {
      await repo.createActivity(title, description);
      await loadActivities(); // refresh
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String id) async {
    try {
      await repo.deleteActivity(id);
      await loadActivities(); // refresh
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
