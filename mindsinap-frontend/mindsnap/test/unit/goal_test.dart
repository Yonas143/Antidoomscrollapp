import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mindsnap/main.dart' as app; // Your app's main entry point
import 'package:mindsnap/features/auth/presentation/login_page.dart';
import 'package:mindsnap/features/dashboard/presentation/user_dashboard.dart'; // Or your target page
// Potentially import providers if you need to override them for mocking
// import 'package:your_app_name/core/providers.dart';
// import 'package:your_app_name/features/auth/data/auth_repository.dart';
// import 'package:mocktail/mocktail.dart'; // If using mocktail

// Mock classes (if you're mocking the repository for controlled testing)
// class MockAuthRepository extends Mock implements AuthRepository {
//   // Implement mock methods for login, returning success or failure based on the test goal
// }

// Helper for pumpAndSettle
extension PumpThenSettle on WidgetTester {
  Future<void> pumpThenSettle({
    Duration duration = const Duration(milliseconds: 100),
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
    Duration? timeout,
  }) async {
    await pump(duration, phase);
    await pumpAndSettle(
        duration, phase, timeout ?? const Duration(seconds: 10));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // late MockAuthRepository mockAuthRepository; // If mocking

  setUpAll(() {
    // mockAuthRepository = MockAuthRepository(); // Initialize mock if used
    // Any global setup for all tests in this file
  });

  group('Authentication Flow Goal Tests', () {
    // TEST SCENARIO BASED ON YOUR GOAL
    testWidgets('Goal: User can log in successfully and see the dashboard', (
        WidgetTester tester) async {
      // ARRANGE
      // If mocking for success:
      // when(() => mockAuthRepository.login(email: 'test@example.com', password: 'password'))
      //   .thenAnswer((_) async => AuthResponse(token: 'fake-token', user: User(id: '1', email: 'test@example.com', name: 'Test')));

      // Start the app. You might wrap with ProviderScope overrides if mocking.
      // For a true E2E, app.main() might be enough if it sets up ProviderScope.
      await tester.pumpWidget(
        ProviderScope(
          // overrides: [
          //   if (usingMock) authRepositoryProvider.overrideWithValue(mockAuthRepository),
          // ],
          child: app
              .MyApp(), // Assuming MyApp is your root widget from main.dart
        ),
      );
      // OR if app.main() handles ProviderScope:
      // app.main();

      // Wait for initial app setup and any redirects (e.g., from splash to login)
      await tester.pumpThenSettle(timeout: const Duration(seconds: 5));
      print('Test: App started and settled.');

      // Ensure we are on the LoginPage
      expect(find.byType(LoginPage), findsOneWidget,
          reason: 'Should start on or navigate to LoginPage');
      print('Test: Verified on LoginPage.');

      // ACT
      // Enter credentials
      await tester.enterText(find.byKey(const Key('login_username_field')),
          'test@example.com'); // Use your test credentials
      await tester.enterText(find.byKey(const Key('login_password_field')),
          'password123'); // Use your test credentials
      print('Test: Credentials entered.');

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button_key')));
      print('Test: Login button tapped.');

      // Wait for async login & navigation
      print('Test: Waiting for login and navigation...');
      await tester.pumpThenSettle(
          timeout: const Duration(seconds: 10)); // Adjust timeout as needed

      // ASSERT
      // Verify navigation to dashboard and login page is gone
      expect(find.byType(LoginPage), findsNothing,
          reason: 'LoginPage should be gone');
      expect(find.byType(UserDashboardPage), findsOneWidget,
          reason: 'Should be on UserDashboardPage');
      print('Test: Verified navigation to UserDashboardPage.');

      // Optional: Verify content on dashboard indicating successful login
      // expect(find.textContaining('Welcome'), findsOneWidget); // Example
      print('Test Goal: "User can log in successfully" - PASSED');
    });

    // Add another testWidgets for a different goal:
    testWidgets(
        'Goal: User sees error on invalid login', (WidgetTester tester) async {
      // ARRANGE:
      // - Mock repository to throw an exception or return an error state.
      // when(() => mockAuthRepository.login(email: 'wrong@example.com', password: 'wrongpassword'))
      //   .thenThrow(Exception('Invalid credentials (mock)')); // Or make your AuthController set an error in AuthState

      await tester.pumpWidget(
        ProviderScope(
          // overrides: [ /* ... */ ],
          child: app.MyApp(),
        ),
      );
      await tester.pumpThenSettle();
      expect(find.byType(LoginPage), findsOneWidget);

      // ACT
      await tester.enterText(
          find.byKey(const Key('login_username_field')), 'wrong@example.com');
      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'wrongpassword');
      await tester.tap(find.byKey(const Key('login_button_key')));
      await tester.pumpThenSettle(); // Allow time for error message to appear

      // ASSERT
      expect(find.byType(UserDashboardPage), findsNothing,
          reason: 'Should NOT navigate on failed login');
      expect(find.byType(LoginPage), findsOneWidget,
          reason: 'Should remain on LoginPage');
      // Check for an error message (SnackBar text, or a Text widget showing the error)
      // Finding SnackBars in tests can be tricky. It's often easier to check if AuthState.error was set
      // and a widget reacting to that error (like a Text widget) is visible.
      // For example, if your LoginPage shows a Text widget with the error:
      // expect(find.textContaining('Invalid credentials'), findsOneWidget);
      print(
          'Test Goal: "User sees error on invalid login" - PASSED (assuming error message appears)');
    });
  });
}