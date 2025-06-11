import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../features/auth/logic/auth_state.dart';
import '../models/activity.dart';
import '../models/goal.dart';
import '../models/user.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/logic/auth_controller.dart';
import '../features/goals/data/goal_repository.dart';
import '../features/goals/logic/goal_controller.dart';
import '../features/mindful_activities/data/activity_repository.dart';
import '../features/mindful_activities/logic/activity_controller.dart';
import '../features/admin/data/user_repository.dart';
import '../features/admin/logic/user_controller.dart';
import '../features/auth/data/auth_repository.dart'; // Make sure this path is correct
import '../features/auth/logic/auth_controller.dart';
import '../features/auth/logic/auth_state.dart';

/// External
final dioProvider = Provider<Dio>((ref) => Dio());

/// Auth
final authRepoProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepository(dio);
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.read(authRepoProvider); // Add repository dependency
  return AuthController(repo); // Pass to controller
});

/// Activities
final activityRepoProvider = Provider<ActivityRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ActivityRepository(dio);
});

// Add missing activity controller
final activityControllerProvider = StateNotifierProvider<ActivityController, List<Activity>>((ref) {
  final repo = ref.read(activityRepoProvider);
  return ActivityController(repo);
});

/// Goals
final goalRepoProvider = Provider<GoalRepository>((ref) {
  final dio = ref.read(dioProvider);
  return GoalRepository(dio);
});

// Specify concrete state type
final goalControllerProvider = StateNotifierProvider<GoalController, AsyncValue<List<Goal>>>((ref) {
  final repo = ref.watch(goalRepoProvider); // Watch your repository provider
  return GoalController(repo);
});
/// Admin - Users
final userRepoProvider = Provider<UserRepository>((ref) {
  final dio = ref.read(dioProvider);
  return UserRepository(dio);
});

// Specify concrete state type
final userControllerProvider = StateNotifierProvider<UserController, List<User>>((ref) {
  final repo = ref.read(userRepoProvider);
  return UserController(repo);
});