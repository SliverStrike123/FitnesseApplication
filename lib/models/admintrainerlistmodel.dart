import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:fitnesseapplication/screens/admintrainerlist.dart' show TrainerListAdminWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrainerListAdminModel extends FlutterFlowModel<TrainerListAdminWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
