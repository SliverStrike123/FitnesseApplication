import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesseapplication/screens/view_application_full.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockCollectionReference extends Mock implements CollectionReference {
  @override
  DocumentReference doc([String? id]) {
    return MockDocumentReference();
  }
}

class MockBuildContext extends Mock implements BuildContext {}

void main() {

  test('rejectApplication updates status to Rejected', () async {
    final fakeFirestore = FakeFirebaseFirestore();
    fakeFirestore.collection('application').add({'status': 'Pending','userId':'11111'});

    final QuerySnapshot query = await fakeFirestore
    .collection('application')
    .where('status', isEqualTo: 'Pending')
    .get();

    
    final String documentID = query.docs.first.id;

    final fullapplication = ViewFullApplication(userId: '11111',);

    fullapplication.rejectApplication(documentID,fakeFirestore);

    // Fetch the updated document
    final updatedDoc = await fakeFirestore.collection('application').doc(documentID).get();
    
    // Check the status field
    expect(updatedDoc['status'], 'Rejected');
  });
}