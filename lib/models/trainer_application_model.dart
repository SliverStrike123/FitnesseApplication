import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:fitnesseapplication/screens/trainer_application.dart' show ApplicationpageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ApplicationpageModel extends FlutterFlowModel<ApplicationpageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textExperience;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textSuitable;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textExperience?.dispose();

    textFieldFocusNode2?.dispose();
    textSuitable?.dispose();
  }
}
