// lib/features/auth/logic/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsnap/features/auth/data/auth_repository.dart'; // Your AuthRepository
import 'package:mindsnap/models/user.dart'; // Your User model
import 'auth_state.dart'; // Your AuthState class

// Assume providers are defined elsewhere (e.g., core/providers.dart)
// final dioProvider = Provider<Dio>((ref) => Dio()); // You need a Dio instance
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return AuthRepository(ref.watch(dioProvider));
// });
//
// final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
//   return AuthController(ref.watch(authRepositoryProvider));
// });

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState.initial()) {
    // No _checkInitialAuthStatus needed if we're not loading from storage.
    // The state is already AuthState(isLoading: false, user: null, token: null, error: null)
    // from AuthState.initial().
    print("AuthController initialized. No token persistence.");
  }

  // Since we don't store the token, we can't restore a session automatically.
  // However, if the token is already in the state (e.g. from a previous hot reload/restart
  // where state was preserved, or if UI re-triggers this), we might try to validate it.
  // This is more relevant if you have a mechanism to re-fetch profile on app resume.
  Future<void> validateCurrentToken() async {
    if (state.token == null || state.token!.isEmpty) {
      print("ValidateCurrentToken: No token in current state.");
      // Ensure user is cleared if token is missing but user object somehow exists
      if(state.user != null) {
        state = state.copyWith(clearUser: true, clearToken: true, isLoading: false);
      }
      return;
    }

    print("ValidateCurrentToken: Attempting to validate token: ${state.token}");
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authRepository.getUserProfile(state.token!);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false); // Token is still valid, update user info if needed
        print("✅ Token validated. User: ${user.id}");
      } else {
        // Token is invalid or expired
        state = state.copyWith(isLoading: false, clearUser: true, clearToken: true, );
        print("⚠️ Token validation failed. Cleared user and token.");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, clearUser: true, clearToken: true, );
      print("❌ Error validating token: $e. Cleared user and token.");
    }
  }


  Future<void> login(String email, String password) async {
    print("🚀 LOGIN ATTEMPT: Email: $email");
    state = state.copyWith(isLoading: true, clearError: true, clearUser: true, clearToken: true);

    try {
      final authResponse = await _authRepository.login(
        email: email.trim(),
        password: password,
      );

      // Token and user are now held in memory in the AuthState
      state = state.copyWith(
        user: authResponse.user,
        token: authResponse.token,
        isLoading: false,
      );
      print("✅ LOGIN SUCCESS: User ID: ${authResponse.user.id}. Token held in memory.");
    } catch (e) {
      print("❌ LOGIN ERROR: $e");
      state = state.copyWith(
        isLoading: false,
      // The repository should throw a user-friendly message
        clearUser: true, // Ensure user and token are cleared on error
        clearToken: true,
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    // Add other fields as necessary
  }) async {
    print("🚀 REGISTER ATTEMPT: Email: $email");
    state = state.copyWith(isLoading: true, clearError: true, clearUser: true, clearToken: true);
    try {
      final authResponse = await _authRepository.register(
        name: name,
        email: email.trim(),
        password: password,
        // ...other fields
      );

      // If registration also logs the user in by returning a token:
      state = state.copyWith(
        user: authResponse.user,
        token: authResponse.token,
        isLoading: false,
      );
      print("✅ REGISTER SUCCESS & LOGGED IN (token in memory): User ID: ${authResponse.user.id}");
    } catch (e) {
      print("❌ REGISTER ERROR: $e");
      state = state.copyWith(
        isLoading: false,

        clearUser: true,
        clearToken: true,
      );
    }
  }

  Future<void> logout() async {
    print("🚀 LOGOUT ATTEMPT");
    // No token to delete from storage. Just clear the state.
    // No need to call a backend logout unless your API specifically requires/supports it
    // for session invalidation on the server even for token-based auth (less common).
    state = AuthState.initial().copyWith(isLoading: false); // Reset to initial, ensure isLoading is false.
    print("✅ LOGOUT SUCCESSFUL (state cleared)");
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(clearError: true);
    }
  }
}