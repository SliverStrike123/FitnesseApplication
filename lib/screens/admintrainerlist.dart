import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:fitnesseapplication/widgets/trainer_list.dart';
import 'package:fitnesseapplication/models/admintrainerlistmodel.dart';
export 'package:fitnesseapplication/models/admintrainerlistmodel.dart';

class TrainerListAdminWidget extends StatefulWidget {
  const TrainerListAdminWidget({super.key});

  @override
  State<TrainerListAdminWidget> createState() => _TrainerListAdminWidgetState();
}

class _TrainerListAdminWidgetState extends State<TrainerListAdminWidget> {
  late TrainerListAdminModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrainerListAdminModel());
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
          title: Text('Trainer List',style: TextStyle(color: Colors.white,fontSize: 20),),
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: true,
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        body: const Column(children: [
          Expanded(child: TrainerList(),)
          
        ],)
      ),
    );
  }
}
