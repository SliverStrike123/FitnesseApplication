import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TrainerScheduleListView extends StatelessWidget {
  final String email;

  TrainerScheduleListView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Add border
        color: Colors.grey[200], // Set background color to light grey
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('schedule')
            .where('email', isEqualTo: email)
            .where('schedule', isGreaterThan: Timestamp.fromDate(DateTime.now()))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final scheduleDocs = snapshot.data!.docs;

          if (scheduleDocs.isEmpty) {
            return Center(child: Text('No schedule found.'));
          }

          return ListView.builder(
            itemCount: scheduleDocs.length,
            itemBuilder: (context, index) {
              final scheduleData = scheduleDocs[index].data() as Map<String, dynamic>;
                Timestamp timestamp = scheduleData['schedule'];
                DateTime dateTime = timestamp.toDate();
                String formattedDate = DateFormat('yyyy-MM-dd, hh:mm a').format(dateTime);
              return Column(
                children: [
                  ListTile(
                    title: Text('Client Name: ${scheduleData['clientname']}'),
                    subtitle: Text('Time: ${formattedDate}'),
                  ),
                  const Divider(
                    color: Colors.black, // Set divider color to black
                  ), 
                ],
              );
              
            },
          );
        },
      ),
    );
  }
}