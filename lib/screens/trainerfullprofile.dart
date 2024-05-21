import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesseapplication/widgets/trainer_schedule_admin.dart';
class TrainerProfileScreen extends StatelessWidget {
  final String trainerId;

  TrainerProfileScreen({required this.trainerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer Profile'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: trainerId)
        .limit(1)
        .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          if (data == null) {
            return Center(child: Text('No data found.'));
          }

           return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Trainer's Picture
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['image_url']),
                      radius: 50,
                    ),
                    SizedBox(width: 20),
                    // Display Trainer's Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${data['username']}', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 8),
                        Text('Email: ${data['email']}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Phone Number: ${data['phonenumber']}', style: TextStyle(fontSize: 16)),
                        // Add more fields as necessary
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20), // Add some space between the trainer info and the schedule list
                Text(
                  'Schedule',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: TrainerScheduleListView(email: data['email']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}