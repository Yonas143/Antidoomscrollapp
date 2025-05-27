// lib/features/auth/logic/auth_state.dart

class AuthState {
  final bool isLoading;
  final String? token;
  final String? error;

  AuthState({
    required this.isLoading,
    this.token,
    this.error,
  });

  factory AuthState.initial() => AuthState(isLoading: false);

  AuthState copyWith({
    bool? isLoading,
    String? token,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      error: error,
    );
  }
}
