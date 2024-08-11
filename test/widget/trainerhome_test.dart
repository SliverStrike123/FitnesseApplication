import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitnesseapplication/screens/trainerhome.dart';

void main() {
  testWidgets('TrainerHomepageWidget UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TrainerHomepageWidget()));

    expect(find.text('Trainer Homepage'), findsOneWidget);

    expect(find.text('View Schedule'), findsOneWidget);

    expect(find.text('View Consultation Requests'), findsOneWidget);

    expect(find.text('Published Workouts'), findsOneWidget);

    expect(find.byIcon(Icons.logout_outlined), findsOneWidget);
  });
}
