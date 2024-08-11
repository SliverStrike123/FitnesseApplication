import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:fitnesseapplication/widgets/applicant_list.dart';


class AdminApplicantList extends StatefulWidget{
  AdminApplicantList({super.key});


  @override
  State<AdminApplicantList> createState() => _AdminApplicantListState();
  
}
class _AdminApplicantListState extends State<AdminApplicantList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          title: Text('Applicant List',style: TextStyle(color: Colors.white,fontSize: 20),),
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: true,
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        body: const Column(children: [
          Expanded(child: ApplicantList(),)
          
        ],)
      ),
    );
  }
  

}