import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fitnesseapplication/widgets/chat_graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChatData {
  ChatData(this.day, this.count);

  final String day;
  final int count;
}

class StatiscalDashboard extends StatelessWidget {
  const StatiscalDashboard({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;
Stream<List<ChatData>> getChatData() {
  return firestore
      .collection('chat')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    var chatData = <ChatData>[];
    var now = DateTime.now();
    var startOfTheWeek = now.subtract(Duration(days: now.weekday - 1));
    var days = List.generate(7, (index) => startOfTheWeek.add(Duration(days: index)));
    var formatter = DateFormat('yyyy-MM-dd');
    for (var day in days) {
      var count = snapshot.docs.where((doc) {
        var createdAt = (doc['createdAt'] as Timestamp).toDate();
        return createdAt.year == day.year && createdAt.month == day.month && createdAt.day == day.day;
      }).length;
      chatData.add(ChatData(formatter.format(day), count));
    }

    return chatData;
  });
}

  Future<String> numberofRole(role) async {
    String number = "";

    QuerySnapshot snapshots = await firestore
        .collection('users')
        .where('userrole', isEqualTo: role)
        .get();

    number = snapshots.docs.length.toString();

    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Statistical Dashboard",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: 150,
              width: 450,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(200, 180, 180, 189),
                    width: 2,
                    style: BorderStyle.solid),
              ),
              child: 
              SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Number of",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Registered Users",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(200, 180, 180, 189),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: FutureBuilder<String>(
                          future: numberofRole('User'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Center(
                                child: Text(
                                  snapshot.data ?? '0',
                                  style: TextStyle(fontSize: 30),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Number of",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Trainers",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(200, 180, 180, 189),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: FutureBuilder<String>(
                          future: numberofRole('Trainer'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Center(
                                child: Text(
                                  snapshot.data ?? '0',
                                  style: TextStyle(fontSize: 30),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),) 
            ),
            const SizedBox(height:30),
            StreamBuilder<List<ChatData>>(
      stream: getChatData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return SfCartesianChart(
           title: ChartTitle(text: 'Public Chat Activity'),
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            LineSeries<ChatData, String>(
              enableTooltip: true, 
              dataSource: snapshot.data,
              xValueMapper: (ChatData chat, _) => chat.day,
              yValueMapper: (ChatData chat, _) => chat.count,
            )
          ],
        );
      },
            )
          ],
        ));
  }
}
