import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Assuming you have a LoginForm widget or a LoginPage with a form like this:
// import 'package:antidoomscrollapp/screens/login_page.dart'; // Or wherever your login form is

// Mock AuthService if your login form interacts with it
class MockAuthService extends Mock {
  Future<bool> login(String email, String password) =>
      super.noSuchMethod(Invocation.method(#login, [email, password]),
          returnValue: Future.value(true));
}

void main() {
  group('Login Widget Tests', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('LoginForm renders correctly with email and password fields', (WidgetTester tester) async {
      // Build the LoginForm widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                // In a real app, you might inject your AuthService here,
                // or the LoginForm might get it from a provider.
                // For this test, we'll assume a basic form.
                return Column(
                  children: [
                    TextField(key: const Key('emailField'), decoration: const InputDecoration(labelText: 'Email')),
                    TextField(key: const Key('passwordField'), obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                    ElevatedButton(
                      key: const Key('loginButton'),
                      onPressed: () {},
                      child: const Text('Login'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verify that email and password fields are present
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('User can enter text into email and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(key: const Key('emailField'), decoration: const InputDecoration(labelText: 'Email')),
                TextField(key: const Key('passwordField'), obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                ElevatedButton(
                  key: const Key('loginButton'),
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );

      // Enter text into the fields
      await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

      // Verify the entered text
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('Tapping login button triggers action (simulated)', (WidgetTester tester) async {
      bool loginAttempted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(key: const Key('emailField'), decoration: const InputDecoration(labelText: 'Email')),
                TextField(key: const Key('passwordField'), obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                ElevatedButton(
                  key: const Key('loginButton'),
                  onPressed: () {
                    loginAttempted = true;
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );

      // Tap the login button
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump(); // Rebuild the widget after the tap

      // Verify that the action was triggered
      expect(loginAttempted, isTrue);
    });

    // Example of testing interaction with a mock service (if your widget calls a service)
    testWidgets('Login with mock service and valid credentials shows success', (WidgetTester tester) async {
      when(mockAuthService.login('valid@example.com', 'password'))
          .thenAnswer((_) async => true);

      // We need a MaterialApp to navigate and show snackbars
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Column(
                  children: [
                    TextField(key: const Key('emailField'), decoration: const InputDecoration(labelText: 'Email')),
                    TextField(key: const Key('passwordField'), obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                    ElevatedButton(
                      key: const Key('loginButton'),
                      onPressed: () async {
                        final email = (find.byKey(const Key('emailField')).evaluate().single.widget as TextField).controller?.text;
                        final password = (find.byKey(const Key('passwordField')).evaluate().single.widget as TextField).controller?.text;

                        if (email != null && password != null) {
                          bool success = await mockAuthService.login(email, password);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Successful')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Failed')),
                            );
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('emailField')), 'valid@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump(); // Pump to show the snackbar
      await tester.pump(const Duration(seconds: 2)); // Give time for the snackbar to appear

      expect(find.text('Login Successful'), findsOneWidget);
      verify(mockAuthService.login('valid@example.com', 'password')).called(1);
    });

    testWidgets('Login with mock service and invalid credentials shows failure', (WidgetTester tester) async {
      when(mockAuthService.login('invalid@example.com', 'wrongpass'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Column(
                  children: [
                    TextField(key: const Key('emailField'), decoration: const InputDecoration(labelText: 'Email')),
                    TextField(key: const Key('passwordField'), obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                    ElevatedButton(
                      key: const Key('loginButton'),
                      onPressed: () async {
                        final email = (find.byKey(const Key('emailField')).evaluate().single.widget as TextField).controller?.text;
                        final password = (find.byKey(const Key('passwordField')).evaluate().single.widget as TextField).controller?.text;

                        if (email != null && password != null) {
                          bool success = await mockAuthService.login(email, password);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Successful')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Failed')),
                            );
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('emailField')), 'invalid@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'wrongpass');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump(); // Pump to show the snackbar
      await tester.pump(const Duration(seconds: 2)); // Give time for the snackbar to appear

      expect(find.text('Login Failed'), findsOneWidget);
      verify(mockAuthService.login('invalid@example.com', 'wrongpass')).called(1);
    });
  });
}
