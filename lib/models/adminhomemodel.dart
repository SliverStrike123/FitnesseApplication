import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:fitnesseapplication/screens/adminhome.dart' show AdminHomeWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminHomeModel extends FlutterFlowModel<AdminHomeWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}