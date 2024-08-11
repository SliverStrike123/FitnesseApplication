import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitnesseapplication/screens/BMI_screen.dart';

void main() {
  group('BMIScreen Tests', () {
    testWidgets('BMI calculation and category display test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: BMIScreen()));

      // Verify the app shows initial text.
      expect(find.text('Calculate BMI'), findsOneWidget);
      expect(find.text('Your BMI is'), findsNothing);

      // Simulate user input.
      await tester.enterText(find.byKey(Key('heightField')), '180');
      await tester.enterText(find.byKey(Key('weightField')), '70');

      // Tap the 'Calculate BMI' button.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate BMI'));
      await tester.pump();

      // Check for updated output.
      expect(find.text('21.6'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
    });
  });
}



