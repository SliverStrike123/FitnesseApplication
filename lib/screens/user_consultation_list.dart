import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'user_book_consultation.dart';

class UserConsoltationList extends StatelessWidget {
  UserConsoltationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Your Consultations"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedule')
                  .where('clientID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('schedule', isGreaterThan: Timestamp.fromDate(DateTime.now()))
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  print('No upcoming consultations.');
                  return Center(child: Text('No upcoming consultations.'));
                }

                var consultations = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: consultations.length,
                  itemBuilder: (context, index) {
                    var consultation = consultations[index];
                    Timestamp scheduleTimestamp = consultation['schedule'];
                    DateTime scheduleDateTime = scheduleTimestamp.toDate();
                    String formattedDate = DateFormat('yyyy-MM-dd, hh:mm a').format(scheduleDateTime);

                    return ListTile(
                      title: Text(consultation['trainername']),
                      subtitle: Text("Date: $formattedDate"),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserBookConsultation()));
              },
              child: Text('Book New Consultation'),
            ),
          ),
        ],
      ),
    );
  }
}