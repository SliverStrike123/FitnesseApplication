import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:fitnesseapplication/screens/trainerhome.dart' show TrainerHomepageWidget;
import 'package:flutter/material.dart';

class TrainerHomepageModel extends FlutterFlowModel<TrainerHomepageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
