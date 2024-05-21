import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesseapplication/widgets/trainer_profile.dart';
import 'package:flutter/material.dart';
import 'package:fitnesseapplication/screens/trainerfullprofile.dart';

class TrainerList extends StatelessWidget{
  const TrainerList({super.key});
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('userrole',isEqualTo: 'Trainer')
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Trainers found.'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }
        final loadedTrainers = chatSnapshots.data!.docs;
        print('Number of trainers: ${loadedTrainers.length}');
        print(loadedTrainers[0].data());
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          itemCount: loadedTrainers.length, 
          itemBuilder: (ctx,index){
            final trainer = loadedTrainers[index].data();
            final nexttrainer= index + 1 < loadedTrainers.length
                ? loadedTrainers[index + 1].data()
                : null;
            return GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TrainerProfileScreen(trainerId: trainer['email'])),
                    );},
              child: TrainerProfile.summary(name: trainer['username'], image: trainer['image_url']),
            );
            
          },
          
          );
  });}
}
  