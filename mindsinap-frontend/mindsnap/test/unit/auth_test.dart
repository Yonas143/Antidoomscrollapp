// test/features/auth/logic/auth_controller_test.dart
import 'package:flutter_test/flutter_test.dart'; // For test/group
import 'package:mocktail/mocktail.dart';
import 'package:mindsnap/features/auth/logic/auth_controller.dart';
import 'package:mindsnap/features/auth/logic/auth_state.dart';
import 'package:mindsnap/features/auth/data/auth_repository.dart';
import 'package:mindsnap/models/user.dart'; // Your User model
import 'package:mindsnap/models/auth_response.dart'; // Your AuthResponse model

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthController authController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    // Assuming AuthController takes AuthRepository directly.
    // If it takes a Ref, you'd mock Ref and how it provides the repository.
    authController = AuthController(mockAuthRepository);
  });

  test('initial state is correct', () {
    expect(authController.debugState, AuthState.initial());
  });

  group('login', () {
    final tUser = User(id: '1', name: 'Test', email: 'test@example.com');
    final tAuthResponse = AuthResponse(token: 'fake-token', user: tUser);
    const tEmail = 'test@example.com';
    const tPassword = 'password';

    test('should emit [loading, success] when login is successful', () async {
      // Arrange
      when(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tAuthResponse);

      // Act
      final future = authController.login(tEmail, tPassword);

      // Assert immediately for loading state
      expect(authController.debugState.isLoading, isTrue);
      expect(authController.debugState.user, isNull);

      await future; // Wait for the async operation to complete

      expect(authController.debugState.isLoading, isFalse);
      expect(authController.debugState.user, tUser);
      expect(authController.debugState.token, 'fake-token');
      expect(authController.debugState.error, isNull);
    });

    test('should emit [loading, error] when login fails', () async {
      // Arrange
      final tException = Exception('Login Failed');
      when(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .thenThrow(tException);

      // Act
      final future = authController.login(tEmail, tPassword);

      // Assert
      expect(authController.debugState.isLoading, isTrue);
      await future;
      expect(authController.debugState.isLoading, isFalse);
      expect(authController.debugState.user, isNull);
      expect(authController.debugState.token, isNull);
      expect(authController.debugState.error,
          contains('Login Failed')); // Or specific error message
    });
  });
  // Add tests for register, logout, etc.
}