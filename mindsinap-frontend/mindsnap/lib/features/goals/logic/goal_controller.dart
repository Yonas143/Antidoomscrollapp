// lib/features/goals/logic/goal_controller.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/goal_repository.dart';
import '../../../models/goal.dart'; // Make sure this import is correct

// ... (your provider definition might be in another file, that's fine)

class GoalController extends StateNotifier<AsyncValue<List<Goal>>> {
  final GoalRepository _repo;

  GoalController(this._repo) : super(const AsyncValue.loading()) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    state = const AsyncValue.loading(); // Set to loading
    try {
      // 1. Get raw data from the repository
      final List<Map<String, dynamic>> rawDataList = await _repo.getGoals();

      // 2. Transform the raw data list into a List<Goal>
      //    This uses the Goal.fromJson factory you defined in Step 1.
      final List<Goal> goals = rawDataList.map((individualMap) {
        return Goal.fromJson(individualMap);
      }).toList();

      // 3. Update the state with the transformed List<Goal>
      state = AsyncValue.data(goals);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Create method (make sure 'platform' and 'dailyLimit' are fields in your Goal model)
  Future<void> create(String platform, int dailyLimit) async {
    // Optionally, keep the current data visible or show a specific loading for create
    // final previousState = state;
    // state = AsyncValue.loading().copyWithPrevious(state); // Example

    try {
      await _repo.createGoal(platform, dailyLimit);
      await loadGoals(); // Reload the full list to see the new item
    } catch (e, st) {
      state = AsyncValue.error(e, st); // .copyWithPrevious(previousState);
    }
  }

  // Delete method
  Future<void> delete(String id) async {
    // Optionally, keep the current data visible or show a specific loading for delete
    // final previousState = state;
    // state = AsyncValue.loading().copyWithPrevious(state); // Example

    try {
      await _repo.deleteGoal(id);
      await loadGoals(); // Reload the list
    } catch (e, st) {
      state = AsyncValue.error(e, st); // .copyWithPrevious(previousState);
    }
  }
}