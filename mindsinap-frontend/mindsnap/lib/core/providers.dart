import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsnap/features/auth/logic/auth_controller.dart';
import 'package:mindsnap/features/mindful_activities/data/activity_repository.dart';
import 'package:mindsnap/features/goals/data/goal_repository.dart';
import 'package:mindsnap/features/admin/data/user_repository.dart';

// AUTH
final authStateProvider = StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(ref),
);

// MINDFUL ACTIVITIES
final activityRepoProvider = Provider<ActivityRepository>(
      (ref) => ActivityRepository(),
);

// GOALS
final goalRepoProvider = Provider<GoalRepository>(
      (ref) => GoalRepository(),
);

// USERS (Admin)
final userRepoProvider = Provider<UserRepository>(
      (ref) => UserRepository(),
);
