import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindsnap/widgets/custom_button.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('CustomButton displays correct label and calls onPressed', (WidgetTester tester) async {
      // Define a flag to check if the button was pressed
      bool buttonPressed = false;

      // Build the CustomButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify that the button displays the correct label
      expect(find.text('Test Button'), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Rebuild the widget after the tap

      // Verify that the onPressed callback was called
      expect(buttonPressed, isTrue);
    });
  });
} 
