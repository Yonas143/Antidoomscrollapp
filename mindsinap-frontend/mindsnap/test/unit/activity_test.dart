// test/features/auth/presentation/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Or Mockito
import 'package:mindsnap/features/auth/logic/auth_controller.dart'; // Your AuthController
import 'package:mindsnap/features/auth/logic/auth_state.dart'; // Your AuthState
import 'package:mindsnap/features/auth/presentation/login_page.dart';
import 'package:mindsnap/core/providers.dart'; // Your authControllerProvider

// --- Mock AuthController ---
class MockAuthController extends StateNotifier<AuthState>
    with Mock
    implements AuthControllerNotifier {
  // `AuthControllerNotifier` would be an interface your AuthController implements,
  // or you directly mock AuthController if its methods are easily mockable.
  // For simplicity, let's assume it has a simple login method.

  MockAuthController(super.state); // Initial state for the mock

// This is a simplified mock. You might need to mock the actual login method
// and control its behavior if AuthControllerNotifier is more complex.
// If your AuthController has a login method like:
// Future<void> login(String email, String password) async { ... }
// You would mock that using Mocktail/Mockito's `when(...).thenAnswer(...)`
}

// Helper to create a ProviderScope with overrides for testing
Widget createLoginPageScreen({
  required AuthControllerNotifier authController, // Use the interface or the concrete class
  // required StateNotifierProvider<AuthControllerNotifier, AuthState> authProviderOverride,
}) {
  return ProviderScope(
    overrides: [
      // This assumes authControllerProvider is StateNotifierProvider<AuthControllerNotifier, AuthState>
      // Adjust if your provider definition is different.
      authControllerProvider.overrideWithValue(
          authController as AuthController),
      // If authControllerProvider is StateNotifierProvider<AuthController, AuthState>
      // and MockAuthController is AuthController, then it's fine.
    ],
    child: const MaterialApp( // MaterialApp needed for navigation context, themes, etc.
      home: LoginPage(),
    ),
  );
}


void main() {
  late MockAuthController mockAuthController;

  setUp(() {
    // Setup mock with an initial state before each test
    mockAuthController = MockAuthController(AuthState.initial());
  });

  group('LoginPage Widget Tests', () {
    testWidgets(
        'renders initial UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
          createLoginPageScreen(authController: mockAuthController));

      expect(find.widgetWithText(TextFormField, 'Username or Email'),
          findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(
          find.widgetWithText(TextButton, 'Don\'t have an account? Register'),
          findsOneWidget);
    });

    testWidgets('shows loading indicator when AuthState is loading', (
        WidgetTester tester) async {
      // Arrange: Update the mock controller's state to be loading
      mockAuthController.state = AuthState.initial().copyWith(isLoading: true);

      await tester.pumpWidget(
          createLoginPageScreen(authController: mockAuthController));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'),
          findsNothing); // Button might be hidden or replaced
    });

    testWidgets(
        'tapping login button calls AuthController.login when form is valid', (
        WidgetTester tester) async {
      // For this, you'd need to properly mock the login method on MockAuthController
      // For example, if AuthControllerNotifier has:
      // Future<void> login(String email, String password);
      //
      // You would use Mocktail:
      // when(() => mockAuthController.login(any(), any())).thenAnswer((_) async {});

      await tester.pumpWidget(
          createLoginPageScreen(authController: mockAuthController));

      // Act
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Username or Email'),
          'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      // Assert
      // verify(() => mockAuthController.login('test@example.com', 'password123')).called(1);
      // This assertion requires Mocktail setup and proper mocking of the login method.
      // For now, this is a placeholder for the concept.
      // A simpler test might be to check if the state tried to become "loading"
      // if your mock isn't sophisticated.
      print(
          "INFO: Test for 'calls AuthController.login' needs proper mocking of the login method in MockAuthController.");
    });

    // Add more tests:
    // - Form validation messages showing
    // - Tapping register button (if it uses context.push, that's harder to unit test here, better for integration)
    // - SnackBar display on error (this can be tricky in widget tests, might need a way to mock ScaffoldMessenger)
  });
}