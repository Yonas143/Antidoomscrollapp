import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository authRepo;
  AuthController(this.authRepo) : super(AuthState.initial());

  Future<void> login(String u, String p) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final t = await authRepo.login(u, p);
      state = state.copyWith(isLoading: false, token: t);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String u, String p) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final t = await authRepo.register(u, p);
      state = state.copyWith(isLoading: false, token: t);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() => state = AuthState.initial();
}
