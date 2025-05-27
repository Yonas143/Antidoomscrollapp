// lib/features/auth/logic/auth_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository authRepo;

  AuthController(this.authRepo) : super(AuthState.initial());

  Future<void> login(String username, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final token = await authRepo.login(username, password);
      state = state.copyWith(isLoading: false, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String username, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final token = await authRepo.register(username, password);
      state = state.copyWith(isLoading: false, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = AuthState.initial();
  }
}
