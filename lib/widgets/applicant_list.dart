import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitnesseapplication/screens/view_application_full.dart';
import 'package:fitnesseapplication/widgets/profile.dart';

class ApplicantList extends StatelessWidget{
  const ApplicantList({super.key});
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('application')
          .where('status',isEqualTo: 'Pending')
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Pending Applicantion found.'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedApplications = chatSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          itemCount: loadedApplications.length, 
          itemBuilder: (ctx,index){
            final application = loadedApplications[index].data();
            final nextapplication = index + 1 < loadedApplications.length
                ? loadedApplications[index + 1].data()
                : null;
            return GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewFullApplication(userId: application['userId'],)),
                    );},
              child: Profile(name:  application['username'], image:  application['userImage']),
            );
            
          },
          
          );
  });}
}
  