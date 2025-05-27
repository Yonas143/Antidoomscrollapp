// lib/features/admin/logic/user_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_repository.dart';

final userControllerProvider = StateNotifierProvider<UserController, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final repo = ref.read(userRepoProvider);
  return UserController(repo);
});

class UserController extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final UserRepository repo;

  UserController(this.repo) : super(const AsyncValue.loading()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final users = await repo.getAllUsers();
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> promote(String id) async {
    try {
      await repo.promoteToAdmin(id);
      await loadUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String id) async {
    try {
      await repo.deleteUser(id);
      await loadUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
