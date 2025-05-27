// lib/features/goals/logic/goal_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/goal_repository.dart';

final goalControllerProvider = StateNotifierProvider<GoalController, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final repo = ref.read(goalRepoProvider);
  return GoalController(repo);
});

class GoalController extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final GoalRepository repo;

  GoalController(this.repo) : super(const AsyncValue.loading()) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    try {
      final data = await repo.getGoals();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> create(String platform, int dailyLimit) async {
    try {
      await repo.createGoal(platform, dailyLimit);
      await loadGoals();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String id) async {
    try {
      await repo.deleteGoal(id);
      await loadGoals();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
