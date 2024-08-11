import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:fitnesseapplication/screens/trainer_published_workout.dart' show TrPublishedWorkoutsWidget;
import 'package:flutter/material.dart';

class TrPublishedWorkoutsModel
    extends FlutterFlowModel<TrPublishedWorkoutsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
