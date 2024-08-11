import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitnesseapplication/screens/nutrition_screen.dart';

void main() {
  testWidgets('NutritionScreen displays and updates meal information',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NutritionScreen()));

    expect(find.text('Chicken Breast (100g)'), findsWidgets);
    expect(find.text('100g, 165 calories'), findsWidgets);

    await tester.tap(find.text('Chicken Breast (100g)').first);
    await tester.pump();

    expect(find.text('Calories Remaining: 3355'), findsOneWidget);
  });
}
