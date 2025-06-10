// lib/features/admin/logic/user_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../data/user_repository.dart';
import '../../../models/user.dart';


class UserController extends StateNotifier<List<User>> {
  final UserRepository repo;
  UserController(this.repo) : super(const AsyncValue.loading() as List<User>) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final users = await repo.getAllUsers();
      state = AsyncValue.data(users) as List<User>;
    } catch (e, st) {
      state = AsyncValue.error(e, st) as List<User>;
    }
  }

  Future<void> promote(String id) async {
    try {
      await repo.promoteToAdmin(id);
      await loadUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st) as List<User>;
    }
  }

  Future<void> delete(String id) async {
    try {
      await repo.deleteUser(id);
      await loadUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st) as List<User>;
    }
  }
}
