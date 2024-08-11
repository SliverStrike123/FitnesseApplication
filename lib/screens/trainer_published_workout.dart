import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:fitnesseapplication/models/trainer_published_workout_model.dart';
export 'package:fitnesseapplication/models/trainer_published_workout_model.dart';

import 'workout_details.dart'; // Import the detailed workout screen
import 'trainer_create_workout.dart';

class TrPublishedWorkoutsWidget extends StatefulWidget {
  const TrPublishedWorkoutsWidget({super.key});

  @override
  State<TrPublishedWorkoutsWidget> createState() =>
      _TrPublishedWorkoutsWidgetState();
}

class _TrPublishedWorkoutsWidgetState extends State<TrPublishedWorkoutsWidget> {
  late TrPublishedWorkoutsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrPublishedWorkoutsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Published Workouts',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22,
                  letterSpacing: 0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final workoutDocs = snapshot.data?.docs ?? [];

              if (workoutDocs.isEmpty) {
                return Center(child: Text('No workouts available'));
              }

              return ListView.builder(
                itemCount: workoutDocs.length,
                itemBuilder: (context, index) {
                  final workout = workoutDocs[index];
                  final workoutData = workout.data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutDetails(title: workoutData['title']),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        workoutData['title'] ?? 'No Title',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0,
                            ),
                      ),
                      subtitle: Text(
                        workoutData['description'] ?? 'No Description',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 20,
                      ),
                      tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                      dense: false,
                    ),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 248, 76, 76),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TrCreateWorkout()),
            );
          },
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 19, 19, 19),
          ),
        ),
      ),
    );
  }
}
