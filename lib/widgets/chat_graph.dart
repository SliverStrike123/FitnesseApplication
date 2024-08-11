import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ChatGraph extends StatefulWidget {
  @override
  _ChatGraphState createState() => _ChatGraphState();
}

class _ChatGraphState extends State<ChatGraph> {
  List<BarChartGroupData> _barGroups = [];
  List<String> lastSevenDays = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchChatData();
  }

  Future<void> _fetchChatData() async {
  try {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

    print("Fetching data from $sevenDaysAgo to $now");

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chat')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .get();

    print("Fetched ${snapshot.docs.length} documents");

    Map<String, int> messageCount = {};

    for (var doc in snapshot.docs) {
      Timestamp timestamp = doc['createdAt'];
      DateTime date = timestamp.toDate();
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      if (!messageCount.containsKey(formattedDate)) {
        messageCount[formattedDate] = 0;
      }
      messageCount[formattedDate] = messageCount[formattedDate]! + 1;
    }

    lastSevenDays = List.generate(7, (index) {
      DateTime day = now.subtract(Duration(days: index));
      return DateFormat('yyyy-MM-dd').format(day);
    }).reversed.toList();

    print("Last seven days: $lastSevenDays");

    setState(() {
      _barGroups = lastSevenDays.map((date) {
        int count = messageCount[date] ?? 0;
        return BarChartGroupData(
          x: lastSevenDays.indexOf(date),
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.blue,
              width: 16,
            ),
          ],
        );
      }).toList();
      isLoading = false;
    });
  } catch (e) {
    print("Error: $e");
    setState(() {
      errorMessage = "Error fetching chat data: $e";
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
      return Column(children: [
        Text('Public Chat Activity',style: TextStyle(fontSize: 20),),


      ],);
    
  }
}