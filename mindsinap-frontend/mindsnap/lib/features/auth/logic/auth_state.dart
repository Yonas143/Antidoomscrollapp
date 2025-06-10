// lib/features/auth/logic/auth_state.dart

class AuthState {
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.token,
    this.isLoading = false,
    this.error,
  });

  factory AuthState.initial() {
    return const AuthState(token: null, isLoading: false, error: null);
  }

  AuthState copyWith({
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
