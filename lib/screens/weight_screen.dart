import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class WeightData {
  final DateTime date;
  final double weight;

  WeightData(this.date, this.weight);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeightScreen(),
    );
  }
}

class WeightScreen extends StatefulWidget {
  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final TextEditingController _weightController = TextEditingController();
  List<WeightData> weightData = [];
  DateTime selectedDate = DateTime.now();

void addWeight() {
  final weight = double.tryParse(_weightController.text);
  if (weight != null) {
    var weightEntry = WeightData(selectedDate, weight);
    var weightDoc = {
      'date': weightEntry.date,
      'weight': weightEntry.weight
    };
    FirebaseFirestore.instance.collection('weights').add(weightDoc).then((value) => print("Weight Added")).catchError((error) => print("Failed to add weight: $error"));
    setState(() {
      weightData.add(weightEntry);
      _weightController.clear();
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a valid weight in kilograms')),
    );
  }
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

LineChartData mainData() {
  List<FlSpot> spots = weightData
      .map((data) => FlSpot(data.date.millisecondsSinceEpoch.toDouble() / (24 * 3600 * 1000), data.weight))
      .toList();

  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final DateTime date = DateTime.fromMillisecondsSinceEpoch((value * 24 * 3600 * 1000).toInt());
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(DateFormat.MMMd().format(date), style: TextStyle(color: Color.fromARGB(255, 18, 18, 19), fontWeight: FontWeight.bold)),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text('${value.toStringAsFixed(1)} kg', style: TextStyle(color: const Color.fromARGB(255, 17, 17, 17), fontWeight: FontWeight.bold));
          },
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: Colors.blueAccent, width: 2),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        barWidth: 2,
        color: Color.fromARGB(255, 10, 10, 10),
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(show: true),
        aboveBarData: BarAreaData(
          show: true,
          color: const Color.fromARGB(255, 247, 248, 248).withOpacity(0.5),
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter your weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor:
                          Colors.white, // Ensuring the text color is white
                    ),
                    child: Text('Select Date'),
                  ),
                  SizedBox(width: 20),
                  Text(DateFormat.yMd().format(selectedDate)),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addWeight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white, // Corrected text color
                ),
                child: Text('Add Weight'),
              ),
              SizedBox(height: 40),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 15, 15, 15)),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LineChart(mainData()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
