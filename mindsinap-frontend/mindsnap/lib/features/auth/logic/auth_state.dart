// lib/features/auth/logic/auth_state.dart
import '../../../models/user.dart'; // Or your actual path to user.dart

class AuthState {
  final bool isLoading;
  final User? user; // Nullable User
  final String? token; // Nullable token
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.token,
    this.error,
  });

  factory AuthState.initial() {
    // When not using secure storage, initial state usually means not logged in and not loading.
    return AuthState(isLoading: false);
  }

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? token,
    String? error,
    bool clearError = false,
    bool clearUser = false,
    bool clearToken = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : user ?? this.user,
      token: clearToken ? null : token ?? this.token,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, user: ${user?.id ?? "null"}, token: ${token != null && token!.isNotEmpty ? "PRESENT" : "ABSENT"}, error: ${error ?? "null"})';
  }
}