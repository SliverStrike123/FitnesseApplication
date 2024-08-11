import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesseapplication/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesseapplication/widgets/trainer_schedule_admin.dart';
import '../auth_state_provider.dart';

final _firebase = FirebaseAuth.instance;

class ViewFullApplication extends StatelessWidget {
  final String userId;

  ViewFullApplication({required this.userId,required});

  void showdialog(context, final status)
  {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Application $status'),
            content: Text('The application has been accepted.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).pop(); 
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
  }
  void acceptApplication(context,documentID,username,imageURL,phonenumber) async {
    FirebaseApp secondary = await Firebase.initializeApp(
      name: "secondary",
      options: Firebase.app().options
    );
    try {
    await FirebaseFirestore.instance
        .collection('application')
        .doc(documentID)
        .update({'status': 'Accepted'});

    final email = username.replaceAll(' ', '').toLowerCase();
    final dummyFirebase = FirebaseAuth.instanceFor(app: secondary);
    final userCredentials = await dummyFirebase.createUserWithEmailAndPassword(
        email: '$email@trainer.com', password: '123456');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user!.uid)
        .set({
      'username': username,
      'email': '$email@trainer.com',
      'phonenumber': phonenumber,
      'image_url': imageURL,
      'userrole': 'Trainer'
    });
  } catch (e) {
    print('Error accepting application: $e');
  } finally {
    await secondary.delete();
  }
  }

  void rejectApplication(documentID,firestore) async {
    await firestore
    .collection('application')
    .doc(documentID)
    .update({'status': 'Rejected'});
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('application')
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final documentID = snapshot.data!.docs.first.id;
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
                      backgroundImage: NetworkImage(data['userImage']),
                      radius: 50,
                    ),
                    SizedBox(width: 20),
                    // Display Trainer's Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${data['username']}',
                            style: TextStyle(fontSize: 20)),
                        SizedBox(height: 8),
                        Text('Email: ${data['email']}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Phone Number: ${data['phonenumber']}',
                            style: TextStyle(fontSize: 16)),
                        // Add more fields as necessary
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                    height:
                        20), // Add some space between the trainer info and the schedule list

                const Text(
                  "Experience",
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  height: 150,
                  width: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  child: Text(data['experience']),
                ),

                const SizedBox(height: 20),
                const Text("Why am I Suitable", style: TextStyle(fontSize: 30)),
                Container(
                  height: 150,
                  width: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  child: Text(data['suitable']),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Center the buttons with some space between them
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                        elevation: 5, // Elevation for shadow
                      ),
                      onPressed: () {
                        acceptApplication(context,documentID,data['username'],data['userImage'],data['phonenumber']);
                        showdialog(context, "Accepted");
                      },
                      child: const Text('Accept',
                          style: TextStyle(color: Colors.white,fontSize: 20)),
                    ),
                    const SizedBox(width:40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                        elevation: 5, // Elevation for shadow
                      ),
                      onPressed: () {
                        rejectApplication(documentID,FirebaseFirestore.instance);
                        showdialog(context, "Rejected");
                      },
                      child: const Text('Reject',
                          style: TextStyle(color: Colors.white,fontSize: 20)),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
