import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TrViewReqWidget extends StatelessWidget {
  const TrViewReqWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation Requests'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trainer_request').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {

                DocumentSnapshot doc = snapshot.data!.docs[index];
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                Timestamp timestamp = data['time'];
                DateTime dateTime = timestamp.toDate();
                String formattedDate = DateFormat('yyyy-MM-dd, hh:mm a').format(dateTime);


                return ListTile(
                  title: Text(data['clientname'], style: TextStyle(color: Colors.black)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time: ${formattedDate}', style: TextStyle(color: Colors.black)),
                      Text('Status: ${data['status']}', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                           final userData = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get();
                    final username = userData.data()?['username'];
                          // Accept the request and move data to 'schedule' collection
                          FirebaseFirestore.instance.collection('schedule').add({
                            'clientID': data['clientid'],
                            'trainername': username,
                            'email': FirebaseAuth.instance.currentUser?.email,
                            ''
                            'clientname': data['clientname'],
                            //'email': data['trainer_email'], this part should be the trainer's email but idk how imma implement it
                            'schedule': data['time'],
                          }).then((value) {
                            // Remove the request from 'trainer_request' collection
                            FirebaseFirestore.instance.collection('trainer_request').doc(doc.id).delete();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Accept', style: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Decline the request and remove it from 'trainer_request' collection
                          FirebaseFirestore.instance.collection('trainer_request').doc(doc.id).delete();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Decline', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
