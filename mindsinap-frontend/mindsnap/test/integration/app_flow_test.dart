import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:antidoomscrollapp/main.dart'; // Assuming your main app is here

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify login and navigation to dashboard', (WidgetTester tester) async {
      // Build the app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Assuming there's a login form
      // Enter username and password
      await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');
      await tester.pumpAndSettle();

      // Tap the login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify navigation to dashboard (e.g., check for a specific text or widget)
      expect(find.text('Welcome to Dashboard'), findsOneWidget); // Replace with actual text on your dashboard
    });

    testWidgets('verify form submission and success message', (WidgetTester tester) async {
      // Assuming you are on a form page
      await tester.pumpWidget(const MyApp()); // Re-launch if needed or navigate to the form page
      await tester.pumpAndSettle();

      // Navigate to the form page (if not already there)
      // Example: await tester.tap(find.byIcon(Icons.form));
      // await tester.pumpAndSettle();

      // Fill out the form fields
      await tester.enterText(find.byKey(const Key('nameField')), 'John Doe');
      await tester.enterText(find.byKey(const Key('emailField')), 'john.doe@example.com');
      await tester.pumpAndSettle();

      // Tap the submit button
      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Form submitted successfully!'), findsOneWidget);
    });
  });
}
