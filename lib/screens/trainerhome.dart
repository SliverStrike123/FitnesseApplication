import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesseapplication/models/trainer_homepage_model.dart';
export 'package:fitnesseapplication/models/trainer_homepage_model.dart';

import 'trainer_view_schedule.dart';
import 'trainer_view_request.dart';
import 'trainer_published_workout.dart';
import 'chat.dart';

class TrainerHomepageWidget extends StatefulWidget {
  const TrainerHomepageWidget({super.key});

  @override
  State<TrainerHomepageWidget> createState() => _TrainerHomepageWidgetState();
}

class _TrainerHomepageWidgetState extends State<TrainerHomepageWidget> {
  late TrainerHomepageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrainerHomepageModel());
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
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'Trainer Homepage',
              style: FlutterFlowTheme.of(context).headlineLarge.override(
                fontFamily: 'Outfit',
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.chat),
              color: const Color.fromARGB(255, 5, 5, 5),
              onPressed: () {
                Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ChatScreen()),
                    );
              },
            ),
          ],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FFButtonWidget( //this one is the view trainer schedule button
                  onPressed: () async {
                    print(FirebaseAuth.instance.currentUser?.email);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TrViewSchedWidget()),
                    );
                  },
                  text: 'View Schedule',
                  options: FFButtonOptions(
                    width: 250,
                    height: 80,
                    color: const Color.fromARGB(255, 248, 76, 76),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                    ),
                    elevation: 3,
                  ),
                ),
                FFButtonWidget( //this one is the view consultation request button
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TrViewReqWidget()),
                    );
                  },
                  text: 'View Consultation Requests',
                  options: FFButtonOptions(
                    width: 250,
                    height: 80,
                    color: const Color.fromARGB(255, 248, 76, 76),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                    ),
                    elevation: 3,
                  ),
                ),
                FFButtonWidget( //This button is to view trainer's published workouts
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TrPublishedWorkoutsWidget()),
                    );
                  },
                  text: 'Published Workouts',
                  options: FFButtonOptions(
                    width: 250,
                    height: 80,
                    color: const Color.fromARGB(255, 248, 76, 76),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                    ),
                    elevation: 3,
                  ),
                ),
                Container( //this one is for the logout button, yet to be implemented
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color.fromARGB(255, 248, 76, 76), width: 1),
                  ),
                  
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FlutterFlowIconButton(
                      buttonSize: 80,
                      fillColor: const Color.fromARGB(255, 248, 76, 76),
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
