// lib/features/goals/logic/goal_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../data/goal_repository.dart';
import '../../../models/goal.dart';


class GoalController extends StateNotifier<List<Goal>> {
  final GoalRepository repo;

  GoalController(this.repo) : super(const AsyncValue.loading() as List<Goal>) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    try {
      final data = await repo.getGoals();
      state = AsyncValue.data(data) as List<Goal>;
    } catch (e, st) {
      state = AsyncValue.error(e, st) as List<Goal>;
    }
  }

  Future<void> create(String platform, int dailyLimit) async {
    try {
      await repo.createGoal(platform, dailyLimit);
      await loadGoals();
    } catch (e, st) {
      state = AsyncValue.error(e, st) as List<Goal>;
    }
  }

  Future<void> delete(String id) async {
    try {
      await repo.deleteGoal(id);
      await loadGoals();
    } catch (e, st) {
      state = AsyncValue.error(e, st) as List<Goal>;
    }
  }
}
