import 'dart:io';
import 'package:fitnesseapplication/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesseapplication/widgets/trainer_list.dart';

final _firebase = FirebaseAuth.instance;

class TrainerHome extends StatefulWidget {
  const TrainerHome ({super.key});
  @override
  State<TrainerHome > createState(){
    return _TrainerHomeState();
  }
}

class _TrainerHomeState extends State<TrainerHome>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: const Center(
        child: TrainerList()
    )
    );
  }
}