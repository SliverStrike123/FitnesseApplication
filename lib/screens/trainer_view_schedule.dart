import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TrViewSchedWidget extends StatelessWidget {
  const TrViewSchedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Schedule'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection('schedule')
        .where('email',isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .where('schedule', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                Timestamp timestamp = data['schedule'];
                DateTime dateTime = timestamp.toDate();
                String formattedDate = DateFormat('yyyy-MM-dd, hh:mm a').format(dateTime);
                // Display schedule data here
                return ListTile(
                  title: Text(data['clientname']),
                  subtitle: Text(formattedDate),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
