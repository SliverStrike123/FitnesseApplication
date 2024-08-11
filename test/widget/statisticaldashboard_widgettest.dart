import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitnesseapplication/screens/statistical_dashboard_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  testWidgets('StatiscalDashboardWidget displays correctly', (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();

    // Add some test data to the fake Firestore
    await fakeFirestore.collection('users').add({
      'userrole': 'User' 
    });
    await fakeFirestore.collection('users').add({
      'userrole': 'Trainer' 
    });

    await fakeFirestore.collection('chat').add({
      'text': 'HI',
      'createdAt': Timestamp.now() 
    });


    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: StatiscalDashboard(firestore: fakeFirestore,),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the presence of elements
    expect(find.text('Statistical Dashboard'), findsOneWidget);
    expect(find.text('Number of'), findsExactly(2));
    expect(find.text('Registered Users'), findsOneWidget);
    expect(find.text('Trainers'), findsOneWidget);
    expect(find.text("1"), findsExactly(2));
    expect(find.byType(SfCartesianChart), findsOneWidget);
  });
}