import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'trainer_application.dart';
import 'chat.dart';
import 'user_consultation_list.dart';

// Placeholder screens for navigation



class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("About Us"),
          backgroundColor:
              Color(0xFFF84C4C) // Example to customize AppBar color
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "About Our Company",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF84C4C) // Theme color for headers
                    ),
              ),
              SizedBox(height: 16),
              Text(
                "At Fit-nesse, we understand the fragmented experience gym-goers face with multiple fitness and nutrient tracking applications."
                "To address this, we have developed an all-in-one solution that seamlessly integrates macro tracking, customized workout plans, and direct connections"
                "with personal trainers. Our app allows users to efficiently monitor their dietary intake, tailor their exercise routines, and easily schedule sessions or seek"
                "advice from personal trainers. Additionally, personal trainers can use our platform to expand their client base, manage appointments, and offer comprehensive dietary"
                "and workout guidance. Our robust admin panel ensures a smooth operation by overseeing trainer applications, monitoring performance, and managing revenue through"
                "commissions. By combining these essential features into a single, user-friendly application, we aim to simplify the fitness journey and enhance the overall"
                "health and wellness experience for both users and trainers alike.",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5, // Line spacing for better readability
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Our Team",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF84C4C),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Our team is composed of industry experts and talented professionals who are "
                "passionate about making a difference. With a commitment to growth and "
                "excellence, we strive to push the boundaries of what is possible.",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// ProfileScreen implementation
class ProfileScreen extends StatelessWidget {
  var applicationStatus = "";
  var username = "";

  void checkApplication() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Thank you for supporting us!",
              style: TextStyle(color: Color(0xFFF84C4C), fontSize: 20),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Consultations'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserConsoltationList()),
            ),
          ),
          
          ListTile(
              leading: Icon(Icons.mail),
              title: Text('Trainer Application'),
              onTap: () async {
                QuerySnapshot query = await FirebaseFirestore.instance
                    .collection('application')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .limit(1)
                    .get();
                
                if (query.docs.isEmpty) {
                  applicationStatus = "No";
                }
                if(query.docs.isNotEmpty){
                  final data = query.docs.first.data() as Map<String, dynamic>;
                  username = data['username'].toString().replaceAll(' ','').toLowerCase();
                  if (data['status'] == 'Pending') {
                  applicationStatus = "Pending";
                } else if (data['status'] == 'Rejected') {
                  applicationStatus = "Rejected";
                  await FirebaseFirestore.instance
                      .collection('application')
                      .doc(query.docs.first.id)
                      .delete();
                } else if (data['status'] == 'Accepted') {
                  applicationStatus = "Accepted";
                } else {
                  applicationStatus = "Error in Fetching";
                }
                } 
                if (applicationStatus == "No") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApplicationpageWidget()),
                  );
                }
                else if (applicationStatus == "Accepted") {
                  showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Congratulations! You have been accepted!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Please log in with the following credentials:'),
            SizedBox(height: 10),
            Text('Email: ${username}@trainer.com'),
            Text('Password: 123456'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
);
                } else if (applicationStatus == "Rejected") {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context){
                      return  AlertDialog(
                    title: Text('Sorry You have been rejected!'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Try Again Next Time!'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                    });
                 
                } else if (applicationStatus == "Pending") {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context){
                      return  AlertDialog(
                    title: Text('Application Still Pending'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Please Wait!'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                    });
                }
              }),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Public Chat'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log out'),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut(); // Sign out
                Navigator.of(context).popUntil((route) =>
                    route.isFirst); // Optionally navigate to the first route
              } catch (e) {
                // Handle exceptions by showing a dialog or a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to sign out')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
